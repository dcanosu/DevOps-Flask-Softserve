##########################
# Virtual Machine -> Outputs
##########################

output "status" {
  description = "✅ Confirmation message for successful VM creation"
  value       = "🚀 VM '${azurerm_linux_virtual_machine.Jenkins.name}' successfully created in region '${azurerm_linux_virtual_machine.Jenkins.location}'"
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.Jenkins.id
}