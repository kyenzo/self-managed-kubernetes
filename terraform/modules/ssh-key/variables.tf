variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "key_algorithm" {
  description = "Algorithm for the key pair"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "RSA key size"
  type        = number
  default     = 4096
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
