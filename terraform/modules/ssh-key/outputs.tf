output "key_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.cluster.key_name
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.cluster.private_key_pem
  sensitive   = true
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

output "public_key_openssh" {
  description = "Public key in OpenSSH format"
  value       = tls_private_key.cluster.public_key_openssh
}
