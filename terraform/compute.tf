resource "azurerm_bastion_host" "attack-range-bastion-host" {
  name                = "AzureBastionHost"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.attack-range-bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.attack-range-bastion-ip.id
  }
}

resource "azurerm_marketplace_agreement" "kali-linux" {
  publisher = "kali-linux"
  offer     = "kali-linux"
  plan      = "kali"
}

resource "azurerm_virtual_machine" "kali" {
  name                             = "kali"
  resource_group_name              = azurerm_resource_group.attack-range-rg.name
  location                         = azurerm_resource_group.attack-range-rg.location
  network_interface_ids            = [azurerm_network_interface.attack-range-network-interface-external-kali-1.id, azurerm_network_interface.attack-range-network-interface-internal-kali-1.id]
  vm_size                          = "Standard_D1_v2"
  primary_network_interface_id     = azurerm_network_interface.attack-range-network-interface-external-kali-1.id
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  depends_on = [azurerm_marketplace_agreement.kali-linux]
  storage_image_reference {
    publisher = "kali-linux"
    offer     = "kali-linux"
    sku       = "kali"
    version   = "latest"
  }

  storage_os_disk {
    name          = "kalidisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "kali"
    admin_username = "kalissh"
    admin_password = var.kali_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Mandatory section for Marketplace VMs
  plan {
    name      = "kali"
    publisher = "kali-linux"
    product   = "kali-linux"
  }
}

resource "azurerm_windows_virtual_machine" "attack-range-ad-1" {
  name                = "ad-1.${var.active_directory_domain}"
  computer_name       = "ad-1"
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  location            = azurerm_resource_group.attack-range-rg.location
  size                = "Standard_F2"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.attack-range-network-interface-ad-1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = azurerm_windows_virtual_machine.attack-range-ad-1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = [azurerm_windows_virtual_machine.attack-range-ad-1]
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.create-domain.rendered)}')) | Out-File -filepath %PUBLIC%\\create-domain.ps1\" && powershell -ExecutionPolicy Unrestricted -File %PUBLIC%\\create-domain.ps1"
    }
SETTINGS
}

data "template_file" "create-domain" {
  template = file("create-domain.ps1")
  vars = {
    kibana-url  = var.kibana_url
    token       = var.fleet_token
    domain-name = var.active_directory_domain
    netbios-name = var.active_directory_netbios_name
  }
}

resource "time_sleep" "wait-4-mins" {
  depends_on = [azurerm_virtual_machine_extension.create-active-directory-forest]
  create_duration = "3m"
}

###Clients

resource "azurerm_windows_virtual_machine" "attack-range-win10-1" {
  name                = "win10-1.${var.active_directory_domain}"
  computer_name       = "win10-1"
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  location            = azurerm_resource_group.attack-range-rg.location
  size                = "Standard_F2"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  depends_on = [time_sleep.wait-4-mins]
  network_interface_ids = [
    azurerm_network_interface.attack-range-network-interface-win10-1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-pron"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "join-domain-1" {
  name                 = "join-domain-1"
  virtual_machine_id   = azurerm_windows_virtual_machine.attack-range-win10-1.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  depends_on = [time_sleep.wait-4-mins]
  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${azurerm_windows_virtual_machine.attack-range-ad-1.admin_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${azurerm_windows_virtual_machine.attack-range-ad-1.admin_password}"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "install-elastic-agent-1v1" {
  name                 = "install-elastic-agent-1v1"
  virtual_machine_id   = azurerm_windows_virtual_machine.attack-range-win10-1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = [time_sleep.wait-4-mins]
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath %PUBLIC%\\install.ps1\" && powershell -ExecutionPolicy Unrestricted -File %PUBLIC%\\install.ps1"
    }
SETTINGS
}

resource "azurerm_windows_virtual_machine" "attack-range-win2k16-1" {
  name                = "win2k16-1.${var.active_directory_domain}"
  computer_name       = "win2k16-1"
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  location            = azurerm_resource_group.attack-range-rg.location
  size                = "Standard_F2"
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  depends_on = [time_sleep.wait-4-mins]
  network_interface_ids = [
    azurerm_network_interface.attack-range-network-interface-win2k16-1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "join-domain-2k16" {
  name                 = "join-domain-2k16"
  virtual_machine_id   = azurerm_windows_virtual_machine.attack-range-win2k16-1.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  depends_on = [time_sleep.wait-4-mins]
  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${azurerm_windows_virtual_machine.attack-range-ad-1.admin_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${azurerm_windows_virtual_machine.attack-range-ad-1.admin_password}"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "install-elastic-agent-2k16v1" {
  name                 = "install-elastic-agent-2k16v1"
  virtual_machine_id   = azurerm_windows_virtual_machine.attack-range-win2k16-1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = [time_sleep.wait-4-mins]
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath %PUBLIC%\\install.ps1\" && powershell -ExecutionPolicy Unrestricted -File %PUBLIC%\\install.ps1"
    }
SETTINGS
}

data "template_file" "tf" {
  template = file("elastic-agent.ps1")
  vars = {
    kibana-url  = var.kibana_url
    token       = var.fleet_token
  }
}

