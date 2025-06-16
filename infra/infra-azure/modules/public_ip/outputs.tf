######################
# Public IP -> Outputs
######################

output "public_ip_id" {
  description = "The resource ID of the public IP address"
  value = azurerm_public_ip.public_ip.id
}

output "public_ip_address" {
  description = "The public IPv4 address"
  value = azurerm_public_ip.public_ip.ip_address
} 