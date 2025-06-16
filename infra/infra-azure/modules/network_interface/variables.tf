################################
# Network Interface -> Variables
################################

variable "name" {
  description = "The name of the virtual machine resource"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration block"
  type        = string
  default     = "internal"
}

variable "subnet_id" {
  description = "ID of the subnet to associate with the NIC"
  type        = string
}

variable "private_ip_allocation_method" {
  description = "Method used to allocate the private IP address"
  type        = string
  default     = "Dynamic"
}

variable "public_ip_id" {
  description = "ID of the Public IP"
  type        = string
}

variable "network_security_group_id" {
  type = string
}
