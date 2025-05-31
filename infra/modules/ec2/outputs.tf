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

output "private_key_pem" {
  description = "Private key for SSH access"
  value       = tls_private_key.app_key.private_key_pem
  sensitive   = true
}
