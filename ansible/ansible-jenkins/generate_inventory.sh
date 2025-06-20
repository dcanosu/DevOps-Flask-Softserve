#!/bin/bash

# if we get any error the script will stop
set -euo pipefail

# Get the absolute path of the project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Configurable variables
TERRAFORM_DIR="$PROJECT_ROOT/infra/infra-azure"
# TERRAFORM_DIR="./infra/infra-azure"
INVENTORY_DIR="$PROJECT_ROOT/ansible/ansible-jenkins/inventory"
INVENTORY_FILE="${INVENTORY_DIR}/jenkins.ini"
PRIVATE_KEY_PATH="~/.ssh/id_rsa"

# Telegram
TELEGRAM_BOT_TOKEN=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMBOTTOKEN" --query value -o tsv)
TELEGRAM_CHAT_ID=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMCHATID" --query value -o tsv)
DEPLOY_MESSAGE="✅ Ansible apply completed successfully at $(date '+%Y-%m-%d %H:%M:%S'). Jenkins server and slave is ready."

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

# Run Ansible Playbook
echo "🚀 Running Ansible playbook to install Jenkins..."
ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_ROOT/ansible/ansible-jenkins/playbook.yml"

# Notify via Telegram if successful
if [[ $? -eq 0 ]]; then
  echo "📣 Notifying Ansible success..."
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d '{
      "chat_id": "'"${TELEGRAM_CHAT_ID}"'",
      "text": "'"${DEPLOY_MESSAGE}"'"
    }'
else
  echo "❌ Ansible playbook failed. No notification sent."
  exit 1
fi