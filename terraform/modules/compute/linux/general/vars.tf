variable "name" {
  default = ""
}

variable "resource_group_name" {
  default = ""
}
variable "location" {
  default = ""
}

variable "network_interface_ids" {
  default = [""]
  type = list(string)
}

variable "admin_user" {
  default = ""
}
variable "admin_password" {
  default = ""
}

variable "image_version" {
  default = "latest"
}
variable "image_sku" {
  default = "18.04-LTS"
}
variable "image_offer" {
  default = "UbuntuServer"
}
variable "image_publisher" {
  default = "Canonical"
}

variable "custom_data" {
  default = ""
}