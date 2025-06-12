output "public_ip_id" {
  description = "El ID del recurso de IP pública"
  value       = azurerm_public_ip.public_ip.id
}

output "public_ip_address" {
  description = "The public IPv4 address"
  value       = azurerm_public_ip.public_ip.ip_address
}
