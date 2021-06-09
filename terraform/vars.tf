variable "admin_user" {
  default = "admin-user"
}
variable "admin_password" {
  default = "G3ner1cPa$sword!"
  description = "AD Password"
}

variable "active_directory_domain" {
  default = "attackrange.com"
}

variable "active_directory_netbios_name" {
  default = "attackrange"
}

variable "kali_password" {
  default = "G3ner1cPa$sword!"
  description = "Kali SSH Password"
}

variable "kibana_url" {
  default = "https://dd655d45ebbc4ac7993ba79c65be59d3.fleet.eastus2.azure.elastic-cloud.com:443"
  description = "Your fleet server URL goes here"
}

variable "fleet_token" {
  default = "emNEaTAza0JVZ1BWeHVEZ0k3VGk6T3VuRDIyZzFTcUdSX2p0WF9vWTFSQQ=="
  description = "The enrollment token goes here"
}
