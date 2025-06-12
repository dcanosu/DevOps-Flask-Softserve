output "nic_id" {
  description = "ID of the Network Interface"
  value       = azurerm_network_interface.nic_jenkins.id
}

output "public_ip_id" {
  description = "Public IP ID attached to the network interface"
  value       = azurerm_network_interface.nic_jenkins.ip_configuration[0].public_ip_address_id
}