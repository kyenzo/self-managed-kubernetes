output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "control_plane_public_ips" {
  description = "Public IPs of control plane nodes"
  value       = module.control_plane.public_ips
}

output "control_plane_private_ips" {
  description = "Private IPs of control plane nodes"
  value       = module.control_plane.private_ips
}

output "worker_public_ips" {
  description = "Public IPs of worker nodes"
  value       = module.workers.public_ips
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value       = module.workers.private_ips
}

output "ssh_key_path" {
  description = "Path to SSH private key"
  value       = module.ssh_key.private_key_path
}

output "ssh_key_name" {
  description = "AWS key pair name"
  value       = module.ssh_key.key_name
}

# Output for Ansible inventory generation
output "ansible_inventory" {
  description = "Ansible inventory data"
  value = {
    control_plane = module.control_plane.instance_details
    workers       = module.workers.instance_details
    ssh_key_path  = module.ssh_key.private_key_path
    ssh_user      = "ubuntu"
  }
}

output "cluster_info" {
  description = "Cluster configuration info"
  value = {
    cluster_name = var.cluster_name
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
    api_server   = length(module.control_plane.public_ips) > 0 ? module.control_plane.public_ips[0] : ""
  }
}
