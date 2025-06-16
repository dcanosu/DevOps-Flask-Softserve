############################
# Virtual machine -> Jenkins
############################

# variable "name" {
#   description = "The name of the virtual machine resource"
#   type        = string
# }

variable "master_vm_name" {
  description = "Name of the master Jenkins VM"
  type        = string
}

variable "slave_vm_name" {
  description = "Name of the slave Jenkins VM"
  type        = string
}

variable "location" {
  description = "Azure location for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
}

variable "admin_vm_slave" {
  description = "Administrator username for the slave VM"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
}

variable "role_master" {
  description = "Rol of the Jenkins Vm"
  type        = string
}

variable "role_slave" {
  description = "Rol of the Jenkins Vm"
  type        = string
}

################################
# Variables for Network security
################################

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

################################
# Network Interface -> Variables
################################

variable "master_network_interface_name" {
  description = "The name of the virtual machine resource"
  type        = string
}

variable "slave_network_interface_name" {
  description = "The name of the virtual machine resource"
  type        = string
}

########################
# Public IP -> Variables
########################

variable "master_public_ip_name" {
  description = "The name of the virtual machine resource"
  type        = string
}

variable "slave_public_ip_name" {
  description = "The name of the virtual machine resource"
  type        = string
}