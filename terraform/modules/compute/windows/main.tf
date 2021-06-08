resource "azurerm_windows_virtual_machine" "windows-vm" {
  name                = var.name
  computer_name       = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  depends_on            = [var.dependency]
  network_interface_ids = "${var.network_interface_ids}"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}