######################
# Network -> Variables
######################

variable "vnet_name" {
  description = "The name of the Virtual Network (VNet)."
  type        = string
  default     = "jenkins-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network in CIDR notation."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "Ubicación de los recursos en Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet within the VNet."
  type        = string
  default     = "jenkins-subnet"
}

variable "subnet_prefix" {
  description = "The address prefix for the subnet in CIDR notation."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}