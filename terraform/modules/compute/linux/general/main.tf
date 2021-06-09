# Create virtual machine
resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                  = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  network_interface_ids            = "${var.network_interface_ids}"
  size                  = "Standard_DS1_v2"

  os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  computer_name  = var.name
  admin_username = var.admin_user
  admin_password = var.admin_password
  disable_password_authentication = false
  custom_data = var.custom_data
}

