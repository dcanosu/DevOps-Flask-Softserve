#!/bin/bash

# Configurable variables
TERRAFORM_DIR="../infra-azure"
INVENTORY_DIR="inventory"
INVENTORY_FILE="${INVENTORY_DIR}/jenkins.ini"
HOST_NAME="Jenkins"
ANSIBLE_USER="jenkinsadmin"
PRIVATE_KEY_PATH="~/.ssh/id_rsa"

# Get the public IP from Terraform output
echo "🔍 Getting public IP from Terraform output..."
IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw public_ip_address)

# Validate that the IP was retrieved successfully
if [[ -z "$IP" ]]; then
  echo "❌ Failed to get public IP from Terraform output."
  exit 1
fi

# Create the inventory directory if it doesn't exist
mkdir -p "$INVENTORY_DIR"

# Generate the Ansible inventory file
cat <<EOF > "$INVENTORY_FILE"
[jenkins]
$HOST_NAME ansible_host=${IP} ansible_user=${ANSIBLE_USER} ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}
EOF

echo "✅ Inventory file created at: $INVENTORY_FILE"
echo "📍 IP address: $IP"
