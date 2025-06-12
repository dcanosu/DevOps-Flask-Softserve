################################
# Variables for Network security
################################

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













variable "name_ec2_sg" {
  description = "Name of the EC2 (Flask) security group"
  type        = string
  default = "flask-app-sg"
}

variable "description" {
  description = "Description of the EC2 (Flask) security group"
  type        = string
  default     = "Allow SSH and Flask HTTP traffic"
}

variable "tcp_protocol" {
  description = "Type of protocol"
  type        = string
  default     = "tcp"
}

variable "ssh_port" {
  description = "SSH port to allow access"
  type        = number
  default     = 22
}

variable "allowed_cidr_blocks_ssh" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this in production!
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP (Flask) access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_port" {
  description = "HTTP port to allow access"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port to allow access"
  type        = number
  default     = 443
}

variable "egress_port" {
  description = "Egress port"
  type        = number
  default     = 0
}

variable "allowed_cidr_blocks_egress" {
  description = "CIDR blocks allowed for outbound"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# variable "port" {
#   description = "Port used by Flask app"
#   type        = number
#   default     = 5000

#   validation {
#     condition     = var.port >= 1 && var.port <= 65535
#     error_message = "The port has to be between 1 and 65535."
#   }
# }

####################
# Variables for RDS
####################

variable "name_rds_sg" {
  description = "Name of the RDS security group"
  type        = string
  default = "rds-App-sg"
}

variable "ec2_security_group_id" {
  description = "ID of the EC2 security group that can access RDS"
  type        = string
  default     = null
}

variable "postgres_port" {
  description = "POSTGRES port to allow access"
  type        = number
  default     = 5432
}