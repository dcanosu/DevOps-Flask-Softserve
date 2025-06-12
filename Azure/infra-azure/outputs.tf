#########################
# Virtual Machine -> Outputs
#########################

output "status" {
  value = module.Jenkins.status
}

output "vm_id" {
  value = module.Jenkins.vm_id
}

#########################
# Network interface -> Outputs
#########################

output "public_ip_address" {
  value       = module.public_ip.public_ip_address
}

output "nic_id" {
  value = module.network_interface.nic_id
}
