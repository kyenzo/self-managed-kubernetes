terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  cluster_name        = var.cluster_name
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  tags                = var.tags
}

# Security Groups Module
module "security_groups" {
  source = "../../modules/security-groups"

  cluster_name      = var.cluster_name
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr
  pod_cidr          = var.pod_cidr
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  tags              = var.tags
}

# SSH Key Module
module "ssh_key" {
  source = "../../modules/ssh-key"

  cluster_name = var.cluster_name
  tags         = var.tags
}

# Control Plane Nodes
module "control_plane" {
  source = "../../modules/ec2"

  cluster_name   = var.cluster_name
  instance_type  = var.control_plane_instance_type
  instance_count = var.control_plane_count
  ami_id         = "" # Use default Ubuntu AMI
  subnet_ids     = module.vpc.public_subnet_ids
  security_group_ids = [
    module.security_groups.common_sg_id,
    module.security_groups.control_plane_sg_id
  ]
  key_name         = module.ssh_key.key_name
  role             = "control-plane"
  root_volume_size = 30
  tags             = var.tags
}

# Worker Nodes
module "workers" {
  source = "../../modules/ec2"

  cluster_name   = var.cluster_name
  instance_type  = var.worker_instance_type
  instance_count = var.worker_count
  ami_id         = "" # Use default Ubuntu AMI
  subnet_ids     = module.vpc.public_subnet_ids
  security_group_ids = [
    module.security_groups.common_sg_id,
    module.security_groups.worker_sg_id
  ]
  key_name         = module.ssh_key.key_name
  role             = "worker"
  root_volume_size = 30
  tags             = var.tags
}
