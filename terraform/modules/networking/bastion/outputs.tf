output "subnet" {
  value = azurerm_subnet.bastion-subnet.id
}

output "public_ip" {
  value = azurerm_public_ip.bastion-ip.id
}