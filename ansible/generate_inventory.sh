#!/bin/bash

# Get the IP from Terraform output
IP=$(terraform -chdir=../infra output -raw public_ip)

# Verificar que la IP fue obtenida correctamente
if [[ -z "$IP" ]]; then
  echo "❌ No se pudo obtener la IP pública. Asegúrate de haber aplicado Terraform correctamente."
  exit 1
fi

# Generate Ansible inventory
cat <<EOF > inventory.ini
[ec2]
app-flask ansible_host=${IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform_key
EOF

echo "✅ Inventory created for IP: $IP"
