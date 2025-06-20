###############################
# Network security -> Variables
###############################

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "Azure location for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}