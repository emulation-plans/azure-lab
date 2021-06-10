module "bastion" {
  source = "./modules/compute/bastion"
  location = module.resource-group.location
  resource_group_name = module.resource-group.resource_group_name
  subnet = module.bastion-networking.subnet
  public_ip_address_id = module.bastion-networking.public_ip
}

module "domain-controller-1" {
  source = "./modules/compute/windows"
  name = "winad-1"
  resource_group_name = module.resource-group.resource_group_name
  location = module.resource-group.location
  admin_user = var.admin_user
  admin_password = var.admin_password
  network_interface_ids = [module.active-directory-interface-1.network-interface-id]
  image_offer = "WindowsServer"
  image_publisher = "MicrosoftWindowsServer"
  image_sku = "2016-Datacenter"
  image_version = "latest"
}

module "create-domain" {
  source = "./modules/extras/create-domain"
  active_directory_domain = var.active_directory_domain
  active_directory_netbios_name = var.active_directory_netbios_name
  fleet_token = var.fleet_token
  kibana_url = var.kibana_url
  virtual_machine_id = module.domain-controller-1.id
}

resource "time_sleep" "wait-4-mins" {
  depends_on = [module.create-domain]
  create_duration = "4m"
}

###Clients

module "win10-1" {
  source = "./modules/compute/windows"
  name = "win10-1"
  resource_group_name = module.resource-group.resource_group_name
  location = module.resource-group.location
  admin_user = var.admin_user
  admin_password = var.admin_password
  depends_on = [time_sleep.wait-4-mins]
  network_interface_ids = [module.windows-10-network-interface-1.network-interface-id]
}

module "join-domain-1" {
  source = "./modules/extras/join-domain"
  name = "join-domain-win10"
  active_directory_domain = var.active_directory_domain
  machine-id = module.win10-1.id
  admin_username = var.admin_user
  admin_password = var.admin_password
  depends_on = [module.win10-1.id]
}

module "elastic-agent-1" {
  source = "./modules/extras/install-agent"
  name = "install-agent-1"
  machine_id = module.win10-1.id
  kibana_url = var.kibana_url
  fleet_token = var.fleet_token
  depends_on = [module.join-domain-1]
}

module "win2k16-1" {
  source = "./modules/compute/windows"
  name = "win2k16-1"
  resource_group_name = module.resource-group.resource_group_name
  location = module.resource-group.location
  admin_user = var.admin_user
  admin_password = var.admin_password
  depends_on = [time_sleep.wait-4-mins]
  network_interface_ids = [module.windows-server-2k16-network-interface-1.network-interface-id]
  image_offer = "WindowsServer"
  image_publisher = "MicrosoftWindowsServer"
  image_sku = "2016-Datacenter"
  image_version = "latest"
}

module "join-domain-2" {
  source = "./modules/extras/join-domain"
  name = "join-domain-2k16"
  active_directory_domain = var.active_directory_domain
  machine-id = module.win2k16-1.id
  admin_username = var.admin_user
  admin_password = var.admin_password
  depends_on = [module.win2k16-1.id]
}

module "elastic-agent-2" {
  source = "./modules/extras/install-agent"
  name = "install-agent-2"
  machine_id = module.win2k16-1.id
  kibana_url = var.kibana_url
  fleet_token = var.fleet_token
  depends_on = [module.join-domain-2]
}

