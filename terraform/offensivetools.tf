module "kali" {
  source = "./modules/compute/linux/kali"
  resource_group_name              = module.resource-group.resource_group_name
  location                         = module.resource-group.location
  network_interface_ids            = [module.kali-external-networking.network-interface-id, module.kali-internal-networking.network-interface-id]
  primary_network_interface_id     = module.kali-external-networking.network-interface-id
  kali_password = var.kali_password
}

module "c2-server" {
  source = "./modules/compute/linux/general"
  name   = "covenant"
  resource_group_name = module.resource-group.resource_group_name
  location = module.resource-group.location
  network_interface_ids = [module.covenant-network-interface-1.network-interface-id]
  admin_password = var.admin_password
  admin_user = var.admin_user
  custom_data = data.template_cloudinit_config.config.rendered
}

data "template_file" "shell-script"{
  template = file("./modules/extras/covenant-install/covenant-install.sh")
  vars = {}
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}