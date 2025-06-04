resource "aws_security_group" "rds_sg" {
  name        = "${var.db_instance_identifier}-rds-sg"
  description = "Security group for RDS instance, allowing access from EC2"

  ingress {
    description       = "Allow PostgreSQL access from EC2 instance"
    from_port         = 5432
    to_port           = 5432
    protocol          = "tcp"
    security_groups   = [var.ec2_security_group_id] # Reference to EC2 SG
  }

  # Egress to anywhere is usually fine for RDS to get updates, etc.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_instance_identifier}-rds-sg"
  }
}

resource "aws_db_instance" "db_app_flask" {
  identifier             = var.db_instance_identifier
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  # parameter_group_name = var.parameter_group_name
  skip_final_snapshot    = true
  publicly_accessible    = false # Make RDS private
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # Assign the new SG
  deletion_protection    = false

  tags = {
    Name = var.db_name
  }
}
