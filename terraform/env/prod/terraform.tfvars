aws_region   = "ca-west-1"
cluster_name = "k8s-prod"

vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["ca-west-1a", "ca-west-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

control_plane_instance_type = "t3.medium"
control_plane_count         = 2

worker_instance_type = "t3.small"
worker_count         = 3

pod_cidr     = "192.168.0.0/16"
service_cidr = "10.96.0.0/12"

allowed_ssh_cidrs = ["0.0.0.0/0"]

tags = {
  Environment = "production"
  ManagedBy   = "terraform"
  Project     = "k8s-self-managed"
}
