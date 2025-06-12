# infra/modules/ec2/main.tf

############################
# Instance EC2 -> app-flask
############################

resource "aws_instance" "app_flask" { # Este es tu recurso existente
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  # subnet_id              = var.subnet_id # Si usas esto, asegúrate de que esté configurado correctamente

  associate_public_ip_address = true # <--- Asegúrate de que esta línea esté, es útil para el user_data y conexión remota.

  root_block_device {
    volume_size         = var.volume_size
    volume_type         = var.volume_type
    delete_on_termination = var.delete_on_termination
  }

  tags = {
    Name = var.instance_name
  }

  # --- CONFIGURACIÓN DE MONITORIZACIÓN (NUEVAS LÍNEAS IMPORTANTES) ---
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_profile.name # <--- ¡ASEGÚRATE DE AÑADIR ESTA LÍNEA!

  user_data = <<-EOF # <--- ¡ASEGÚRATE DE AÑADIR TODO ESTE BLOQUE user_data!
              #!/bin/bash
              # Update and install necessary packages
              sudo apt update -y
              sudo apt install -y awscli -y

              # Install CloudWatch Agent (for Ubuntu/Debian)
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
              sudo dpkg -i /tmp/amazon-cloudwatch-agent.deb || sudo apt-get install -f -y # Instala dependencias si falla

              # Configure CloudWatch Agent
              cat << 'EOT' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "run_as_user": "root"
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "${aws_cloudwatch_log_group.instance_log_group.name}",
                          "log_stream_name": "{instance_id}/syslog"
                        },
                        {
                          "file_path": "/var/log/cloud-init-output.log",
                          "log_group_name": "${aws_cloudwatch_log_group.instance_log_group.name}",
                          "log_stream_name": "{instance_id}/cloud-init-output"
                        }
                      ]
                    }
                  },
                  "metrics_collected": {
                    "collect_all": true
                  }
                }
              }
              EOT

              # Start CloudWatch Agent
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
              EOF
}