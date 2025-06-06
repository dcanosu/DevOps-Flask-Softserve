#########################
# Instance EC2 -> Outputs
#########################

output "status" {
  value = module.ec2_app_flask.status
}

output "instance_id" {
  value = module.ec2_app_flask.instance_id
}

output "public_ip" {
  value = module.ec2_app_flask.public_ip
}

###############################
# RDS using postgres -> Outputs
###############################

output "rds_status" {
  value = module.rds_db_app_flask.status
}

output "rds_endpoint" {
  value = module.rds_db_app_flask.rds_endpoint
}

output "rds_db_name" {
  value = module.rds_db_app_flask.rds_db_name
}

output "rds_port" {
  value = module.rds_db_app_flask.rds_port
}
