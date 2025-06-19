#!/bin/bash

# if we get any error the script will stop
set -euo pipefail

# Get the absolute path of the script location
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TERRAFORM_DIR="$PROJECT_ROOT/infra/infra-azure"
ANSIBLE_DIR="$PROJECT_ROOT/ansible/ansible-jenkins"
INVENTORY_FILE="$ANSIBLE_DIR/inventory/jenkins.ini"
PLAYBOOK_FILE="$ANSIBLE_DIR/playbook.yml"

# Telegram
TELEGRAM_BOT_TOKEN=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMBOTTOKEN" --query value -o tsv)
TELEGRAM_CHAT_ID=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMCHATID" --query value -o tsv)
DEPLOY_MESSAGE="✅ Terraform apply completed successfully at $(date '+%Y-%m-%d %H:%M:%S'). AZURE - Infrastructure is ready."

echo "🧱 Initializing and applying Terraform configuration..."
cd "$TERRAFORM_DIR"
terraform init -upgrade
terraform validate
terraform apply -auto-approve

echo "📣 Notifying Terraform success..."
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "'"${TELEGRAM_CHAT_ID}"'",
    "text": "'"${DEPLOY_MESSAGE}"'"
  }'

echo "📥 Generating Ansible inventory..."
cd "$ANSIBLE_DIR"
./generate_inventory.sh

# Check if inventory was created
if [[ ! -f "$INVENTORY_FILE" ]]; then
  echo "❌ Inventory file not found: $INVENTORY_FILE"
  exit 1
fi

echo "🚀 Running Ansible playbook to install Jenkins..."
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE"