variable "resource_group_name" {
  default = ""
}
variable "virtual_network_name" {
  default = ""
}
variable "bastion_address_prefixes" {
  default = [""]
  type    = list(string)
}
variable "location" {
  default = ""
}