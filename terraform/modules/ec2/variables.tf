variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
}

variable "ami_id" {
  description = "AMI ID for the instances (leave empty for latest Ubuntu 22.04)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet IDs for instances"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "role" {
  description = "Role of the instance (control-plane or worker)"
  type        = string
  validation {
    condition     = contains(["control-plane", "worker"], var.role)
    error_message = "Role must be 'control-plane' or 'worker'."
  }
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
