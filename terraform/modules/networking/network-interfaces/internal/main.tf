resource "azurerm_network_interface" "internal-interface" {
  name                = "${var.name}-internal-interface"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = "${var.dns_servers}"
  ip_configuration {
    name                          = "kali_internalnic"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "static"
    private_ip_address            = var.private_ip_address
  }
}