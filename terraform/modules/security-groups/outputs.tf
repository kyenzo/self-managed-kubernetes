output "common_sg_id" {
  description = "ID of common security group"
  value       = aws_security_group.common.id
}

output "control_plane_sg_id" {
  description = "ID of control plane security group"
  value       = aws_security_group.control_plane.id
}

output "worker_sg_id" {
  description = "ID of worker security group"
  value       = aws_security_group.worker.id
}
