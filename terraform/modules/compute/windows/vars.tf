variable "name" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}
variable "location" {
  default = ""
}
variable "size" {
  default = "Standard_F2"
}
variable "admin_user" {
  default = ""
}
variable "admin_password" {
  default = ""
}
variable "network_interface_ids" {
  default = [""]
  type = list(string)
}
variable "dependency" {
  default = ""
}
variable "image_version" {
  default = "latest"
}
variable "image_sku" {
  default = "21h1-pron"
}
variable "image_offer" {
  default = "Windows-10"
}
variable "image_publisher" {
  default = "MicrosoftWindowsDesktop"
}
