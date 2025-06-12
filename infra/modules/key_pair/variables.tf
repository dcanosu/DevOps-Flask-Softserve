###########################
# Key pair EC2 -> Variables
###########################

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default = "terraform_key"
}

variable "ssh_public_key" {
  description = "Path to the public SSH key file"
  type        = string
}
