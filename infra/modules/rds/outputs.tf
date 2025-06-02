output "status" {
  description = "✅ Confirmation message for successful RDS creation"
  value       = "🚀 DB for App_flask successfully created"
}

output "endpoint" {
  value = aws_db_instance.db_app_flask.endpoint
}