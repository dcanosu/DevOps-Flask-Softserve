# #########################
# # Virtual Machine -> Outputs
# #########################

output "jenkins_status" {
  value = "✅ VM '${var.master_vm_name}' successfully created in region '${var.location}'"
}

output "jenkins_slave_status" {
  value = "✅ VM '${var.slave_vm_name}' successfully created in region '${var.location}'"
}

######################
# Public IP -> Outputs
######################

output "jenkins_public_ip_address" {
  value = module.jenkins_public_ip.public_ip_address
}

output "jenkins_slave_public_ip_address" {
  value = module.jenkins_slave_public_ip.public_ip_address
}

output "jenkins_admin_user" {
  value = var.admin_username
}

output "jenkins_slave_admin_user" {
  value = var.admin_vm_slave
}
