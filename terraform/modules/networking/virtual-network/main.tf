resource "azurerm_virtual_network" "virtual-network" {
  name                = "${var.name}-virtual-network"
  address_space       = "${var.address_space}"
  location            = var.location
  resource_group_name = var.resource_group_name
}