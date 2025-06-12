# #####################
# # RDS using Postgress
# #####################

resource "aws_db_instance" "db_app_flask" {
  identifier           = var.db_instance_identifier
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  # vpc_security_group_ids = [var.db_sg_id]
  # db_subnet_group_name   = var.db_subnet_group_name
  
  skip_final_snapshot  = true
  publicly_accessible  = false
  deletion_protection  = false
  multi_az               = false

  tags = {
    Name = var.db_name
  }
}