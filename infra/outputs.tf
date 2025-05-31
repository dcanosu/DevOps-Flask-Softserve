########## EC2 ##########

output "ec2_status" {
  value = module.ec2_app_flask.status
}

output "ec2_instance_id" {
  value = module.ec2_app_flask.instance_id
}

output "ec2_public_ip" {
  value = module.ec2_app_flask.public_ip
}

output "ec2_private_key_pem" {
  value     = module.ec2_app_flask.private_key_pem
  sensitive = true
}

########## RDS ##########

output "rds_status" {
  value = module.rds_db_app_flask.status
}

output "rds_endpoint" {
  value = module.rds_db_app_flask.endpoint
}
