variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "pod_cidr" {
  description = "CIDR block for pods (CNI)"
  type        = string
  default     = "192.168.0.0/16"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
