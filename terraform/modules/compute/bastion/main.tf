resource "azurerm_bastion_host" "attack-range-bastion-host" {
  name                = "AzureBastionHost"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet
    public_ip_address_id = var.public_ip_address_id
  }
}