variable "aws_region" {
  description = "AWS region to deploy EC2"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID used to launch the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "Size of the root EBS volume (in GiB)"
  type        = number
}

########## RDS ##########
variable "db_instance_identifier" {
  description = "The unique identifier for the RDS PostgreSQL instance. Must be lowercase and without spaces."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type    = string
}

variable "username" {
  description = "Username for the master DB user."
  type    = string
}

variable "password" {
  description = "Password for the master DB user. Marked as sensitive for security."
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 instances"
  type        = string
}