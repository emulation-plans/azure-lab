variable "name" {
  default = "kali"
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
variable "primary_network_interface_id" {
  default = ""
}

variable "kali_password" {
  default = ""
}

variable "kali_depends" {
  default = ""
}

