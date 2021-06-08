resource "azurerm_marketplace_agreement" "kali-linux" {
  publisher = "kali-linux"
  offer     = "kali-linux"
  plan      = "kali"
}

resource "azurerm_virtual_machine" "kali" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  network_interface_ids            = "${var.network_interface_ids}"
  vm_size                          = "Standard_D1_v2"
  primary_network_interface_id     = var.primary_network_interface_id
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