##########################
# Instance EC2 -> Outputs
##########################

output "status" {
  description = "✅ Confirmation message for successful EC2 instance creation"
  value       = "🚀 EC2 instance '${var.instance_name}' successfully created in region '${var.aws_region}'"
}

output "instance_id" {
  description = "Id of instance 'app_flask'"
  value       = aws_instance.app_flask.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance 'app_flask'"
  value       = aws_instance.app_flask.public_ip
}