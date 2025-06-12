############################
# Virtual machine -> Jenkins
############################

variable "name" {
  description = "The name of the virtual machine resource"
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

# variable "nic_id" {
#   description = "ID of the network interface attached to the VM"
#   type        = string
# }

variable "public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
}

################################
# Variables for Network security
################################

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "Azure location for resources"
  type        = string
}
