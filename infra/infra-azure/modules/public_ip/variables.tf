########################
# Public IP -> Variables
########################

variable "name" {
  description = "The name of the virtual machine resource"
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be deployed"
  type = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type = string
}


variable "public_ip_allocation_method" {
  description = "Defines the allocation method for the public IP address"
  type        = string
  default     = "Static" # Basic
}

variable "public_ip_sku" {
  description = "Specifies the SKU for the public IP (Basic or Standard)"
  type        = string
  default     = "Standard"
}