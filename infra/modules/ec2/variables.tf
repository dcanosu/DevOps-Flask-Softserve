variable "aws_region" {
  description = "AWS region to deploy EC2"
  type        = string
  default     = "us-east-1" # N. Virgigina
}

variable "ami_id" {
  description = "The AMI ID used to launch the EC2 instance"
  type        = string
  default     = "ami-0953476d60561c955" # Amazon linux 2023
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Tag to assign as the instance Name"
  type        = string
	default     = "flask-app-dev"
}

variable "volume_size" {
  description = "Size of the root EBS volume (in GiB)"
  type        = number
  default     = 10
}

variable "volume_type" {
  description = "Type of EBS volume (e.g., gp3, gp2, standard)"
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  description = "Whether to delete the root volume when the instance is terminated"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}

# variable "subnet_id" {
#   description = "The Subnet ID where the instance will be launched"
#   type        = string
# }

# variable "security_group_ids" {
#   description = "List of Security Group IDs to associate with the instance"
#   type        = list(string)
# }
# variable "key_name" {
#   description = "The name of the SSH key pair to use for the instance"
#   type        = string
# }
