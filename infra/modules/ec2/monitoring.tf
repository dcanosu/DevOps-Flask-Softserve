# infra/modules/ec2/monitoring.tf

# IAM Role for EC2 to send logs to CloudWatch
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.instance_name}-cloudwatch-role" # Using instance_name for uniqueness

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
    Name        = "${var.instance_name}-cloudwatch-role"
    Environment = "development"
  }
}

# Attach policy to the IAM Role for CloudWatch Logs
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy_attachment" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "${var.instance_name}-cloudwatch-profile" # Using instance_name for uniqueness
  role = aws_iam_role.ec2_cloudwatch_role.name
}

# CloudWatch Log Group for EC2 instance logs
resource "aws_cloudwatch_log_group" "instance_log_group" {
  name              = "/ec2/${var.instance_name}" # Name the log group based on instance_name
  retention_in_days = 7                    # Retención de logs en días

  tags = {
    Name        = "${var.instance_name}-logs"
    Environment = "development"
  }
}

# CloudWatch Alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "${var.instance_name}-high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 80 # 80% CPU
  alarm_description   = "This alarm monitors EC2 CPU utilization for ${var.instance_name}"
  actions_enabled     = true

  dimensions = {
    InstanceId = aws_instance.app_flask.id # <--- CORREGIDO: Usando app_flask
  }

  tags = {
    Name        = "${var.instance_name}-high-cpu-alarm"
    Environment = "development"
  }
}

# CloudWatch Alarm for instance status check failed
resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm" {
  alarm_name          = "${var.instance_name}-status-check-failed-instance"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This alarm monitors if the EC2 instance status check failed for ${var.instance_name}"
  actions_enabled     = true

  dimensions = {
    InstanceId = aws_instance.app_flask.id # <--- CORREGIDO: Usando app_flask
  }

  tags = {
    Name        = "${var.instance_name}-status-check-failed-alarm"
    Environment = "development"
  }
}