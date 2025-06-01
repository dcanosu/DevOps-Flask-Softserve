resource "aws_instance" "app_flask" {
  ami           = var.ami_id
  instance_type = var.instance_type
	key_name              = aws_key_pair.app_key.key_name
	vpc_security_group_ids = [aws_security_group.app_sg.id]  # Use the security group
  #   subnet_id     = var.subnet_id

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }
  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "app_key" {
  key_name   = "flask-app-key"
  public_key = var.ssh_public_key
  
  tags = {
    Name = "public-app-key"
    Purpose = "Ansible"
  }
}

# Security group for EC2
resource "aws_security_group" "app_sg" {
  name        = "flask-app-sg"
  description = "Security group for Flask app"
  
  ingress {
		description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production!
  }
  
  ingress {
		description = "Flask app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
		description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "flask-app-sg"
  }
}
