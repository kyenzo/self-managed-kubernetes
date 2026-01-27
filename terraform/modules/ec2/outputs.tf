output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.node[*].id
}

output "private_ips" {
  description = "Private IPs of the instances"
  value       = aws_instance.node[*].private_ip
}

output "public_ips" {
  description = "Public IPs of the instances"
  value       = aws_instance.node[*].public_ip
}

output "instance_details" {
  description = "Details of all instances"
  value = [for i, instance in aws_instance.node : {
    id         = instance.id
    name       = instance.tags["Name"]
    private_ip = instance.private_ip
    public_ip  = instance.public_ip
    role       = var.role
  }]
}
