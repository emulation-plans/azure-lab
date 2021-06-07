variable "admin_user" {
  default = "adminuser"
}
variable "admin_password" {
  default = "P@ssw0rd!"
  description = "AD Password"
}

variable "active_directory_domain" {
  default = "elasticdemo.com"
}

variable "active_directory_netbios_name" {
  default = "elasticdemo"
}

variable "kali_password" {
  default = "P@ssw0rd!"
  description = "Kali SSH Password"
}

variable "kibana_url" {
  default = ""
  description = "Your kibana endpoint URL goes here"
}

variable "fleet_token" {
  default = "Grab your enrollment token from Fleet in Kibana and set it"
}
