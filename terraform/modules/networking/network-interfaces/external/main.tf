resource "azurerm_public_ip" "public-ip" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "external-interface" {
  name                = "${var.name}-external-interface"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = "${var.dns_servers}"

  ip_configuration {
    primary                       = true
    name                          = "${var.name}external-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }
}