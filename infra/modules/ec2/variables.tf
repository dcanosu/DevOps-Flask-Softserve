############################
# Instance EC2 -> Variables
############################

variable "aws_region" {
  description = "AWS region where the EC2 instance will be deployed"
  type        = string
  default     = "us-east-1" # N. Virginia
}

variable "instance_name" {
  description = "Tag to assign as the instance Name"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID used to launch the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
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

variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group"
  type        = string
}

# variable "subnet_id" {
#   description = "The Subnet ID where the instance will be launched"
#   type        = string
# }