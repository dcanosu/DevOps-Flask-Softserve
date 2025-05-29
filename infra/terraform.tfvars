aws_region        = "us-east-1"
instance_name     = "App-flask"
ami_id = "ami-084568db4383264d4" # Ubuntu Server 24.04 LTS
volume_size = 9
 
########## RDS ##########
db_instance_identifier = "db-app-flask"
db_name = "db_app_flask"
username = "postgres"
password = "postgres"