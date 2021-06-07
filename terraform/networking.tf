resource "azurerm_resource_group" "attack-range-rg" {
  name     = "attack-range-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "attack-range-virtual-network" {
  name                = "attack-range-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
}

resource "azurerm_subnet" "attack-range-virtual-subnet-1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.attack-range-rg.name
  virtual_network_name = azurerm_virtual_network.attack-range-virtual-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "attack-range-virtual-subnet-2" {
  name                 = "internal-red"
  resource_group_name  = azurerm_resource_group.attack-range-rg.name
  virtual_network_name = azurerm_virtual_network.attack-range-virtual-network.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "attack-range-bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.attack-range-rg.name
  virtual_network_name = azurerm_virtual_network.attack-range-virtual-network.name
  address_prefixes     = ["10.0.1.224/27"]
}

resource "azurerm_public_ip" "attack-range-bastion-ip" {
  name                = "AzureBastionIp"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "attack-range-public-ip-kali-1" {
  name                = "kali-1-public-ip"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "attack-range-network-interface-external-kali-1" {
  name                = "kali-1-external"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  dns_servers         = [azurerm_network_interface.attack-range-network-interface-ad-1.private_ip_address]

  ip_configuration {
    primary                       = true
    name                          = "kali_externalnic"
    subnet_id                     = azurerm_subnet.attack-range-virtual-subnet-2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.attack-range-public-ip-kali-1.id
  }
}

resource "azurerm_network_interface" "attack-range-network-interface-internal-kali-1" {
  name                = "kali-1-internal"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  ip_configuration {
    name                          = "kali_internalnic"
    subnet_id                     = azurerm_subnet.attack-range-virtual-subnet-1.id
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.2.66"
  }
}

resource "azurerm_network_interface" "attack-range-network-interface-ad-1" {
  name                = "ad-nic"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.attack-range-virtual-subnet-1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.10"
  }
}

resource "azurerm_network_interface" "attack-range-network-interface-win10-1" {
  name                = "win10-1-nic"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  dns_servers         = [azurerm_network_interface.attack-range-network-interface-ad-1.private_ip_address]
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.attack-range-virtual-subnet-1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.11"
  }
}

resource "azurerm_network_interface" "attack-range-network-interface-win2k16-1" {
  name                = "win2k16-1-nic"
  location            = azurerm_resource_group.attack-range-rg.location
  resource_group_name = azurerm_resource_group.attack-range-rg.name
  dns_servers         = [azurerm_network_interface.attack-range-network-interface-ad-1.private_ip_address]
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.attack-range-virtual-subnet-1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.14"
  }
}


