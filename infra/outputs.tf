output "status" {
  value = module.ec2_app_flask.status
}

output "instance_id" {
  value = module.ec2_app_flask.instance_id
}

output "public_ip" {
  value = module.ec2_app_flask.public_ip
}

########## RDS ##########
output "status_db" {
  value = module.rds_db_app_flask.status
}

output "rds_endpoint" {
  value = module.rds_db_app_flask.rds_endpoint
}
