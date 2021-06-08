variable "name" {
  default = ""
}

variable "resource_group_name" {
  default = ""
}

variable "location" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "private_ip_address" {
  default = ""
}

variable "dns_servers" {
  default = ["168.63.129.16"]
  type = list(string)
}