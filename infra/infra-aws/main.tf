terraform {
  required_version = ">= 1.3.0" # Ensures compatibility with Terraform v1.3 or higher

  backend "azurerm" {
    resource_group_name   = "terraform-rg"
    storage_account_name  = "tfstateflaskapp"
    container_name        = "tfstateaws"
    key                   = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider
      version = "~> 5.0"        # Use any version compatible with 5.x
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "security_group_flask" {
  source  = "./modules/security_group"
}

module "key_pair" {
  source = "./modules/key_pair"
  ssh_public_key = file("~/.ssh/terraform_key.pub")
}

module "ec2_app_flask" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_name      = var.instance_name
  aws_region         = var.aws_region
  volume_size        = var.volume_size
  key_name           = module.key_pair.key_name
  security_group_id  = module.security_group_flask.security_group_id
}

module "rds" {
  source                = "./modules/rds"
  db_instance_identifier = var.db_instance_identifier
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_sg_id                = module.security_group_flask.rds_security_group_id
}