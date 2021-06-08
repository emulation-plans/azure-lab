module "resource-group" {
  source   = "./modules/networking/resource-group"
  name     = "attack-range-rg"
  location = "West Europe"
}

module "virtual-network" {
  source              = "./modules/networking/virtual-network"
  name                = "attack-range-vnet"
  resource_group_name = module.resource-group.resource_group_name
  location            = module.resource-group.location
  address_space       = ["10.0.0.0/16"]
}

module "subnet-1" {
  source               = "./modules/networking/subnet"
  name                 = "internal"
  resource_group_name  = module.resource-group.resource_group_name
  virtual_network_name = module.virtual-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "subnet-2" {
  source               = "./modules/networking/subnet"
  name                 = "internal-red"
  resource_group_name  = module.resource-group.resource_group_name
  virtual_network_name = module.virtual-network.name
  address_prefixes     = ["10.0.3.0/24"]
}

module "bastion-networking" {
  source                   = "./modules/networking/bastion"
  resource_group_name      = module.resource-group.resource_group_name
  location                 = module.resource-group.location
  virtual_network_name     = module.virtual-network.name
  bastion_address_prefixes = ["10.0.1.224/27"]
}

module "kali-external-networking" {
  source              = "./modules/networking/network-interfaces/external"
  name                = "kali"
  location            = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  dns_servers         = [module.active-directory-interface-1.private_ip_address]
  subnet_id           = module.subnet-2.id
}

module "kali-internal-networking" {
  source              = "./modules/networking/network-interfaces/internal"
  name                = "kali"
  location            = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  subnet_id           = module.subnet-2.id
  private_ip_address  = "10.0.2.69"
}

module "active-directory-interface-1" {
  source              = "./modules/networking/network-interfaces/internal"
  name                = "active-directory-nic"
  location            = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  subnet_id           = module.subnet-1.id
  private_ip_address  = "10.0.2.10"
}

module "windows-10-network-interface-1" {
  source              = "./modules/networking/network-interfaces/internal"
  name                = "win10-nic-1"
  location            = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  dns_servers         = [module.active-directory-interface-1.private_ip_address]
  subnet_id           = module.subnet-1.id
  private_ip_address  = "10.0.2.11"
}

module "windows-server-2k16-network-interface-1" {
  source              = "./modules/networking/network-interfaces/internal"
  name                = "win2k16-nic-1"
  location            = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  dns_servers         = [module.active-directory-interface-1.private_ip_address]
  subnet_id           = module.subnet-1.id
  private_ip_address  = "10.0.2.12"
}



