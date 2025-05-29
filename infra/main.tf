terraform {
  required_version = ">= 1.3.0" # Ensures compatibility with Terraform v1.3 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider
      version = "~> 5.0"         # Use any version compatible with 5.x
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ec2_app_flask" {
  source = "./modules/ec2" # Path to your EC2 module
  ami_id                = var.ami_id
  instance_name         = var.instance_name
  aws_region            = var.aws_region 
  volume_size           = var.volume_size
}

module "rds_db_app_flask" {
  source = "./modules/rds"
  db_instance_identifier = var.db_instance_identifier
  db_name = var.db_name
  username = var.username
  password = var.password
}