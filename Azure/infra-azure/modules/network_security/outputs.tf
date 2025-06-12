###########################
# Network security -> Outputs
###########################

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.jenkins_nsg.id
}