terraform {
  required_version = ">= 1.3.0" # Ensures compatibility with Terraform v1.3 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider
      version = "~> 5.0"        # Use any version compatible with 5.x
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- IAM Role and Instance Profile for EC2 to send logs to CloudWatch ---
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "EC2CloudWatchRole-flask-app-${var.instance_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2CloudWatchRole-${var.instance_name}"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" # AWS managed policy
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2CloudWatchInstanceProfile-flask-app-${var.instance_name}"
  role = aws_iam_role.ec2_cloudwatch_role.name
}


module "ec2_app_flask" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_name      = var.instance_name
  aws_region         = var.aws_region
  volume_size        = var.volume_size
  key_name           = module.key_pair.key_name
  security_group_id  = module.security_group_flask.security_group_id

  # --- MODIFIED: Pass the IAM instance profile and user_data for CloudWatch Agent ---
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent

              # Create directories for Gunicorn logs if they don't exist
              mkdir -p /var/log/gunicorn
              chmod 755 /var/log/gunicorn

              # Create CloudWatch Agent configuration file
              cat << 'EOT' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/messages",
                          "log_group_name": "/ec2/flask-app/${var.instance_name}/system-messages",
                          "log_stream_name": "{instance_id}"
                        },
                        {
                          "file_path": "/var/log/gunicorn/access.log", # COMMON GUNICORN ACCESS LOG
                          "log_group_name": "/ec2/flask-app/${var.instance_name}/gunicorn-access",
                          "log_stream_name": "{instance_id}"
                        },
                        {
                          "file_path": "/var/log/gunicorn/error.log", # COMMON GUNICORN ERROR LOG
                          "log_group_name": "/ec2/flask-app/${var.instance_name}/gunicorn-error",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              EOT

              # Start the CloudWatch agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

              # --- IMPORTANT: Ensure your Gunicorn setup is configured to write logs to these files ---
              # For example, in your Gunicorn service file or startup command, you would use:
              # gunicorn --bind 0.0.0.0:8000 --access-logfile /var/log/gunicorn/access.log --error-logfile /var/log/gunicorn/error.log your_app:app

              EOF
}

module "security_group_flask" {
  source = "./modules/security_group"
}

module "key_pair" {
  source         = "./modules/key_pair"
  ssh_public_key = file("~/.ssh/terraform_key.pub")
}

module "rds" {
  source                 = "./modules/rds"
  db_instance_identifier = var.db_instance_identifier
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  ec2_security_group_id  = module.security_group_flask.security_group_id

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
}