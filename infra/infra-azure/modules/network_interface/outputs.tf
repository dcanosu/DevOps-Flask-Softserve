############################
# Network Interface -> Outputs
############################

output "nic_id" {
  description = "ID of the Network Interface"
  value = azurerm_network_interface.nic.id
}
