variable "name" {
  default = ""
}
variable "address_space" {
  default = [""]
  type = list(string)
}
variable "location" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}