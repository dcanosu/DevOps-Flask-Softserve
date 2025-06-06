########################
# Security Group for EC2
########################

resource "aws_security_group" "flask_sg" {
  name        = var.name_ec2_sg
  description = var.description
  #vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.allowed_cidr_blocks_ssh
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound"
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1" # Validated this protocol because it for default allow all traffic for any port
    cidr_blocks = var.allowed_cidr_blocks_egress
  }

  tags = {
    Name = var.name_ec2_sg
  }
}

########################
# Security Group for RDS
########################

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow DB access only from EC2 SG"

  dynamic "ingress" {
    for_each = var.ec2_security_group_id != null ? [var.ec2_security_group_id] : []
    content {
      description     = "Allow PostgreSQL access from EC2 instance"
      from_port       = var.postgres_port
      to_port         = var.postgres_port
      protocol        = var.tcp_protocol
      security_groups = [ingress.value]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1" # Validated this protocol because it for default allow all traffic for any port
    cidr_blocks = var.allowed_cidr_blocks_egress
  }

  tags = {
    Name = var.name_rds_sg
  }
}