variable "db_instance_identifier" {
  description = "The unique identifier for the RDS PostgreSQL instance. Must be lowercase and without spaces."
  type        = string
  default     = "postgres-db"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes. Minimum for MySQL is 20 GB on some regions."
  type    = number
  default = 10
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type    = string
  default = "my_db"
}

variable "engine" {
  description = "The database engine to use (e.g., mysql, postgres, etc.)."
  type    = string
  default = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine to use."
  type    = string
  default = "16.4"
}

variable "instance_class" {
  description = "The instance type of the RDS. db.t3.micro is included in the AWS Free Tier."
  type    = string
  default = "db.t3.micro"
}

variable "username" {
  description = "Username for the master DB user."
  type    = string
  default = "flask"
}

variable "password" {
  description = "Password for the master DB user. Marked as sensitive for security."
  type      = string
  sensitive = true
}

# variable "parameter_group_name" {
#   description = "The name of the DB parameter group to associate with this instance."
#   type    = string
#   default = "default.postgres15"
# }
