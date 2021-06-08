output "network-interface-id" {
  value = azurerm_network_interface.internal-interface.id
}

output "private_ip_address" {
  value = azurerm_network_interface.internal-interface.private_ip_address
}