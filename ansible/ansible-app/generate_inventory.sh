#!/bin/bash

# Get the IP from Terraform output
IP=$(terraform -chdir=../infra output -raw public_ip)

# Check the IP 
if [[ -z "$IP" ]]; then
  echo "❌ we can't get the public ip."
  exit 1
fi

# Generate Ansible inventory
cat <<EOF > inventory.ini
[ec2]
app-flask ansible_host=${IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform_key
EOF

echo "✅ Inventory created for IP: $IP"
