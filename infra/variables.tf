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