# Instancia app-flask
resource "aws_instance" "app_flask" {
  ami           = var.ami_id
  instance_type = var.instance_type
  #   subnet_id     = var.subnet_id
  # vpc_security_group_ids = [aws_security_group.flask_sg.id]
  #   key_name      = var.key_name

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }
  tags = {
    Name = var.instance_name
  }
}