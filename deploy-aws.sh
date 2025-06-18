#!/bin/bash

# if we get any error the script will stop
set -euo pipefail

# Get the absolute path of the script location
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TERRAFORM_DIR="$PROJECT_ROOT/infra/infra-aws"
ANSIBLE_DIR="$PROJECT_ROOT/ansible/ansible-app"
INVENTORY_FILE="$ANSIBLE_DIR/inventory/app.ini"
PLAYBOOK_FILE="$ANSIBLE_DIR/playbook.yml"

echo "🧱 Initializing and applying Terraform configuration..."
cd "$TERRAFORM_DIR"
terraform init -upgrade
terraform validate
terraform apply -auto-approve

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