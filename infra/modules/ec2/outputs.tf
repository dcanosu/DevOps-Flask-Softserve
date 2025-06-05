output "status" {
  description = "✅ Confirmation message for successful EC2 instance creation"
  value       = "🚀 EC2 instance for App_flask successfully created in region ${var.aws_region}"
}

output "instance_id" {
  description = "Id of instance app_flask"
  value       = aws_instance.app_flask.id
}

output "public_ip" {
  description = "Public ip of app_flask"
  value       = aws_instance.app_flask.public_ip
}

output "security_group_id" {
  description = "ID of the EC2 instance security group"
  value       = aws_security_group.app_sg.id
}
