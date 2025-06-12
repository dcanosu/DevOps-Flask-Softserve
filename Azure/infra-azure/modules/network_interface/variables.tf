variable "nic_name" {
  description = "Name of the NIC"
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

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the Public IP"
  type        = string
}

variable "nsg_id" {
  description = "ID of the Network Security Group"
  type        = string
}
