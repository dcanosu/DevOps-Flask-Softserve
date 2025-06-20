####################
# Network -> Outputs
####################

output "subnet_id" {
  description = "ID de la subred creada"
  value       = azurerm_subnet.subnet.id
}

output "vnet_id" {
  description = "ID de la red virtual creada"
  value       = azurerm_virtual_network.vnet.id
}
