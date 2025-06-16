#!/bin/bash

set -e # if we get any error the script will stop

# Get the absolute path of the script location
PROJECT_ROOT=$(dirname "$(readlink -f "$0")")

echo "🧱 Applying Terraform..."
cd "$PROJECT_ROOT/infra/infra-aws"
terraform init -upgrade
terraform validate
terraform apply -auto-approve

echo "📥 Generating Ansible inventory..."
cd "$PROJECT_ROOT/ansible/ansible-app"
./generate_inventory.sh

echo "🚀 Running Ansible Playbook..."
ansible-playbook -i inventory.ini app_flask.yml