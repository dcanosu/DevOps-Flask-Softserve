#!/bin/bash

# Configurable variables
TERRAFORM_DIR="../infra-azure"
INVENTORY_DIR="inventory"
INVENTORY_FILE="${INVENTORY_DIR}/jenkins.ini"
# HOST_NAME="Jenkins"
# ANSIBLE_USER="jenkinsadmin"
PRIVATE_KEY_PATH="~/.ssh/id_rsa"

# Get the public IP from Terraform output
echo "🔍 Getting public IP from Terraform output..."
# IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw jenkins_public_ip_address)
MASTER_IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw jenkins_public_ip_address)
SLAVE_IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw jenkins_slave_public_ip_address)
ANSIBLE_USER=$(terraform -chdir="$TERRAFORM_DIR" output -raw jenkins_admin_user)
SLAVE_USER=$(terraform -chdir="$TERRAFORM_DIR" output -raw jenkins_slave_admin_user)


# Validate that the IP was retrieved successfully
# if [[ -z "$IP" ]]; then
if [[ -z "$MASTER_IP" || -z "$SLAVE_IP" ]]; then
  echo "❌ Failed to get one or both public IPs from Terraform output."
  exit 1
fi

# Create the inventory directory if it doesn't exist
mkdir -p "$INVENTORY_DIR"

# Generate the Ansible inventory file
# [jenkins]
# $HOST_NAME ansible_host=${IP} ansible_user=${ANSIBLE_USER} ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}
cat <<EOF > "$INVENTORY_FILE"
[jenkins]
Jenkins ansible_host=${MASTER_IP} ansible_user=${ANSIBLE_USER} ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}

[jenkins_slave]
JenkinsSlave ansible_host=${SLAVE_IP} ansible_user=${SLAVE_USER} ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}
EOF

echo "✅ Inventory file created at: $INVENTORY_FILE"
# echo "📍 IP address: $IP"
echo "📍 Jenkins Master IP: $MASTER_IP"
echo "📍 Jenkins Slave IP: $SLAVE_IP"