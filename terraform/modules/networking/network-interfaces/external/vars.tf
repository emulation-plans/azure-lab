variable "name" {
  default = ""
}

variable "resource_group_name" {
  default = ""
}

variable "location" {
  default = ""
}

variable "dns_servers" {
  default = [""]
  type = list(string)
}

variable "subnet_id" {
  default = ""
}

variable "public_ip_address_id" {
  default = ""
}