#!/bin/bash

# if we get any error the script will stop
set -euo pipefail

# Get the absolute path of the script location
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TERRAFORM_DIR="$PROJECT_ROOT/infra/infra-aws"
ANSIBLE_DIR="$PROJECT_ROOT/ansible/ansible-app"

# Telegram secrets
TELEGRAM_BOT_TOKEN=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMBOTTOKEN" --query value -o tsv)
TELEGRAM_CHAT_ID=$(az keyvault secret show --vault-name "telegram-secrets" --name "TELEGRAMCHATID" --query value -o tsv)
# DEPLOY_MESSAGE="✅ Terraform apply completed successfully at $(date '+%Y-%m-%d %H:%M:%S'). AWS - Infrastructure is ready."


echo "🧱 Initializing and applying Terraform configuration..."
cd "$TERRAFORM_DIR"
terraform init -upgrade
terraform validate
terraform apply -auto-approve

IP=$(terraform -chdir="$TERRAFORM_DIR" output -raw public_ip)

# Succes message
DEPLOY_SUCCESS_MESSAGE=$(cat <<EOF
✅ *Terraform Deployment Report*
📦 *Module:* \`infra-aws\`  
🌍 *IP:* \`${IP:-N/A}\`  
🕒 *Time:* $(date '+%Y-%m-%d %H:%M:%S')  
🚀 *Status:* Infrastructure deployed successfully.
EOF
)

# Error message
DEPLOY_ERROR_MESSAGE=$(cat <<EOF
❌ *Terraform Deployment Report*
📦 *Module:* \`infra-aws\`  
🌍 *IP:* \`${IP:-N/A}\`  
🕒 *Time:* $(date '+%Y-%m-%d %H:%M:%S')  
🚫 *Status:* Failed during terraform apply.  
🔍 Check Terraform logs or pipeline output.
EOF
)

echo "📣 Notifying Terraform success..."
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "'"${TELEGRAM_CHAT_ID}"'",
    "text": "'"${DEPLOY_SUCCESS_MESSAGE}"'",
    "parse_mode": "Markdown"
  }'

cd "$ANSIBLE_DIR"
./generate_inventory.sh