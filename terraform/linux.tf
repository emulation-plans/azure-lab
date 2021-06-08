module "kali" {
  source = "./modules/compute/linux/kali"
  resource_group_name              = module.resource-group.resource_group_name
  location                         = module.resource-group.location
  network_interface_ids            = [module.kali-external-networking.network-interface-id, module.kali-internal-networking.network-interface-id]
  primary_network_interface_id     = module.kali-external-networking.network-interface-id
  kali_password = var.kali_password
}