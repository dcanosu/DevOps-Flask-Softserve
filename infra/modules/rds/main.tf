# RDS in Postgress
resource "aws_db_instance" "db_app_flask" {
  identifier           = var.db_instance_identifier
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  # parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  publicly_accessible  = false
  deletion_protection  = false

  tags = {
    Name = var.db_name
  }
}
