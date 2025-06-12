###########################
# Security Group -> Outputs
###########################

output "security_group_id" {
  description = "The ID of the security group for EC2"
  value       = aws_security_group.flask_sg.id
}

# output "rds_sg_id" {
#   description = "The ID of the security group for RDS"
#   value       = aws_security_group.rds_sg.id
# }
