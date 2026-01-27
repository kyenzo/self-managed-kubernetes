#!/bin/bash
# Destroy all infrastructure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

echo "=========================================="
echo "  Destroying Kubernetes Cluster"
echo "=========================================="
echo ""
echo "WARNING: This will destroy all infrastructure!"
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

cd "$PROJECT_ROOT/terraform/env/prod"
terraform destroy

echo ""
echo "Infrastructure destroyed."
