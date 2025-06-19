#!/bin/bash

# if we get any error the script will stop
set -euo pipefail

# Get the absolute path of the project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Configurable paths
TERRAFORM_DIR="$PROJECT_ROOT/infra/infra-aws"
INVENTORY_DIR="$PROJECT_ROOT/ansible/ansible-app/inventory"
INVENTORY_FILE="${INVENTORY_DIR}/app.ini"
PRIVATE_KEY_PATH="~/.ssh/terraform_key"

# Telegram secrets from Azure
TELEGRAM_BOT_TOKEN=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMBOTTOKEN" --query value -o tsv)
TELEGRAM_CHAT_ID=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMCHATID" --query value -o tsv)
# DEPLOY_MESSAGE="✅ Ansible apply completed successfully at $(date '+%Y-%m-%d %H:%M:%S'). App is ready."

# Get the public IP from Terraform output
echo "🔍 Getting public IP from Terraform output..."
IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw public_ip)

# Validate that the IP was retrieved successfully
if [[ -z "$IP" ]]; then
  echo "❌ we can't get the public ip from Terraform output."
  exit 1
fi

DEPLOY_SUCCESS_MESSAGE=$(cat <<EOF
🚀 *Ansible Deployment Report*
📦 *Role:* \`app-flask\`  
🌍 *IP:* \`${IP:-N/A}\`  
🕒 *Time:* $(date '+%Y-%m-%d %H:%M:%S')  
✅ *Status:* Success. App is ready.
EOF
)

# Error message
DEPLOY_ERROR_MESSAGE=$(cat <<EOF
🚀 *Ansible Deployment Report*
📦 *Role:* \`app-flask\`  
🌍 *IP:* \`${IP:-N/A}\`  
🕒 *Time:* $(date '+%Y-%m-%d %H:%M:%S')  
❌ *Status:* Failed during playbook execution.  
🔍 Check logs on the server or CI pipeline.
EOF
)

# Generate Ansible inventory
echo "📥 Generating Ansible inventory..."
cat <<EOF > "$INVENTORY_FILE"
[app]
app-flask ansible_host=${IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform_key
EOF

echo "✅ Inventory file created at: $INVENTORY_FILE"
echo "📍 App address IP: $IP"

# Run Ansible Playbook
echo "🚀 Running Ansible playbook to install App dependencies..."
if ansible-playbook -i "$INVENTORY_FILE" "$PROJECT_ROOT/ansible/ansible-app/playbook.yml"; then
  echo "📣 Notifying Ansible success..."
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d '{
      "chat_id": "'"${TELEGRAM_CHAT_ID}"'",
      "text": "'"${DEPLOY_SUCCESS_MESSAGE}"'",
      "parse_mode": "Markdown"
    }'
else
  echo "❌ Ansible playbook failed. Notifying error..."
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d '{
      "chat_id": "'"${TELEGRAM_CHAT_ID}"'",
      "text": "'"${DEPLOY_ERROR_MESSAGE}"'",
      "parse_mode": "Markdown"
    }'
  exit 1
fi