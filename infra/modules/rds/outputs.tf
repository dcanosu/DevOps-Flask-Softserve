# ###############################
# # RDS using postgres -> Outputs
# ###############################

output "rds_status" {
  description = "✅ Confirmation message for successful RDS instance creation"
  value       = "🚀 RDS instance '${var.db_instance_identifier}' successfully created"
}

output "rds_endpoint" {
  description = "🔗 Endpoint to connect to the RDS PostgreSQL instance"
  value       = aws_db_instance.db_app_flask.endpoint
}

output "rds_db_name" {
  description = "📚 Name of the PostgreSQL database"
  value       = aws_db_instance.db_app_flask.db_name
}

output "rds_port" {
  description = "🔒 Port on which the RDS PostgreSQL instance is listening"
  value       = aws_db_instance.db_app_flask.port
}
