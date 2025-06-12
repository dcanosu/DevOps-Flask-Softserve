############################
# Virtual Machine -> Variables
############################

variable "name" {
  description = "The name of the virtual machine resource"
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be deployed"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "size" {
  description = "Size of the virtual machine (e.g., Standard_B1s)"
  type        = string
  default     = "Standard_B1s" # Free tier eligible
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  sensitive = true
}

variable "public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "nic_id" {
  description = "ID of the network interface attached to the VM"
  type        = string
}

variable "image_publisher" {
  description = "The publisher of the image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "The SKU of the image"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "The version of the image"
  type        = string
  default     = "latest"
}
