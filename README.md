# Self-Managed Kubernetes Cluster on AWS

Infrastructure as Code for deploying a self-managed Kubernetes cluster on AWS EC2 instances using Terraform and Ansible.

## Architecture

| Component | Instance Type | Count | Cost/hr |
|-----------|--------------|-------|---------|
| Control Plane | t3.medium | 2 | ~$0.04 each |
| Workers | t3.small | 3 | ~$0.02 each |
| **Total** | | 5 | **~$0.14/hr** |

**Features:**
- Real nodes you can stop/start to simulate failure
- Demonstrates cordoning when a node goes down
- Calico CNI for pod networking
- kubeadm-based cluster initialization

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.5.0
- [Ansible](https://www.ansible.com/) >= 2.14
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials

## Deployment

### 1. Provision Infrastructure

```bash
cd terraform/env/prod
terraform init
terraform apply
```

### 2. Configure Ansible Inventory

Get the IPs from Terraform:
```bash
terraform output control_plane_public_ips
terraform output control_plane_private_ips
terraform output worker_public_ips
terraform output worker_private_ips
```

Edit `ansible/inventory/hosts.ini` and fill in the IPs:
```ini
[control_plane]
cp1 ansible_host=<public_ip_1> private_ip=<private_ip_1>
cp2 ansible_host=<public_ip_2> private_ip=<private_ip_2>

[workers]
worker1 ansible_host=<public_ip_1> private_ip=<private_ip_1>
worker2 ansible_host=<public_ip_2> private_ip=<private_ip_2>
worker3 ansible_host=<public_ip_3> private_ip=<private_ip_3>

[k8s_cluster:children]
control_plane
workers

[primary_control_plane]
cp1
```

### 3. Deploy Kubernetes Cluster

```bash
cd ansible
ansible-playbook playbooks/site.yml
```

This installs containerd, Kubernetes packages, initializes the control plane with Calico CNI, and joins all worker nodes.

## Access the Cluster

```bash
# SSH to control plane
ssh -i terraform/env/prod/keys/k8s-prod-key.pem ubuntu@<control-plane-ip>

# Verify cluster
kubectl get nodes
kubectl get pods -A
```

## Test Deployment

```bash
# Create a test deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort

# Get the NodePort
kubectl get svc nginx
```

## Simulate Node Failure

You can stop/start EC2 instances to simulate node failures:

```bash
# Stop a worker node from AWS Console or CLI
aws ec2 stop-instances --instance-ids <instance-id>

# Watch the node go NotReady
kubectl get nodes -w

# The node will be marked NotReady after ~40 seconds
# Pods will be rescheduled after the pod-eviction-timeout (default 5 minutes)
```

## Directory Structure

```
.
├── terraform/
│   ├── modules/
│   │   ├── vpc/              # VPC, subnets, IGW
│   │   ├── security-groups/  # K8s security rules
│   │   ├── ssh-key/          # SSH key pair
│   │   └── ec2/              # EC2 instances
│   └── env/prod/             # Production environment
└── ansible/
    ├── inventory/            # Hosts and group vars
    ├── roles/                # Ansible roles
    │   ├── common/           # System preparation
    │   ├── container-runtime/# containerd
    │   ├── kubernetes/       # kubeadm, kubelet, kubectl
    │   ├── control-plane/    # Cluster init, Calico
    │   └── worker/           # Worker join
    └── playbooks/            # Deployment playbooks
```

## Configuration

Edit `terraform/env/prod/terraform.tfvars` to customize:

```hcl
aws_region   = "ca-west-1"
cluster_name = "k8s-prod"

control_plane_instance_type = "t3.medium"
control_plane_count         = 2

worker_instance_type = "t3.small"
worker_count         = 3

pod_cidr     = "192.168.0.0/16"
service_cidr = "10.96.0.0/12"
```

## Cleanup

### Option 1: Reset Cluster (keep VMs running)
```bash
cd ansible
ansible-playbook playbooks/cluster-reset.yml
# Then redeploy with: ansible-playbook playbooks/site.yml
```

### Option 2: Destroy Everything
```bash
cd terraform/env/prod
terraform destroy
```

## Network CIDRs

| Network | CIDR |
|---------|------|
| VPC | 10.0.0.0/16 |
| Subnet 1 | 10.0.1.0/24 |
| Subnet 2 | 10.0.2.0/24 |
| Pod Network | 192.168.0.0/16 |
| Service Network | 10.96.0.0/12 |

## Security Groups

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | 0.0.0.0/0 | SSH |
| 6443 | TCP | 0.0.0.0/0 | Kubernetes API |
| 2379-2380 | TCP | VPC | etcd |
| 10250 | TCP | VPC | Kubelet API |
| 10259 | TCP | VPC | kube-scheduler |
| 10257 | TCP | VPC | kube-controller-manager |
| 30000-32767 | TCP | 0.0.0.0/0 | NodePort Services |
| 179 | TCP | VPC | Calico BGP |
| 4789 | UDP | VPC | Calico VXLAN |

