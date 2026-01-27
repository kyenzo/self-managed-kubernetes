#!/bin/bash
# Full deployment script for self-managed Kubernetes cluster

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

echo "=========================================="
echo "  Self-Managed Kubernetes Cluster Deploy"
echo "=========================================="
echo ""

# Step 1: Terraform
echo "Step 1: Provisioning infrastructure with Terraform..."
echo "------------------------------------------------------"
cd "$PROJECT_ROOT/terraform/env/prod"

terraform init
terraform plan -out=tfplan
terraform apply tfplan

echo ""
echo "Infrastructure provisioned successfully!"
echo ""

# Step 2: Generate Ansible inventory
echo "Step 2: Generating Ansible inventory..."
echo "---------------------------------------"
cd "$SCRIPT_DIR"
./generate-inventory.sh

echo ""

# Step 3: Wait for instances to be ready
echo "Step 3: Waiting for instances to be ready (60 seconds)..."
echo "---------------------------------------------------------"
sleep 60

# Step 4: Run Ansible
echo "Step 4: Configuring cluster with Ansible..."
echo "--------------------------------------------"
cd "$PROJECT_ROOT/ansible"
ansible-playbook playbooks/site.yml

echo ""
echo "=========================================="
echo "  Deployment Complete!"
echo "=========================================="
echo ""

# Get outputs
cd "$PROJECT_ROOT/terraform/env/prod"
SSH_KEY_PATH=$(terraform output -raw ssh_key_path)
CONTROL_PLANE_IP=$(terraform output -json control_plane_public_ips | jq -r '.[0]')

echo "To access the cluster:"
echo ""
echo "  ssh -i $SSH_KEY_PATH ubuntu@$CONTROL_PLANE_IP"
echo ""
echo "Then run:"
echo "  kubectl get nodes"
echo ""
