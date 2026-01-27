resource "tls_private_key" "cluster" {
  algorithm = var.key_algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "cluster" {
  key_name   = "${var.cluster_name}-key"
  public_key = tls_private_key.cluster.public_key_openssh

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-key"
  })
}

resource "local_file" "private_key" {
  content         = tls_private_key.cluster.private_key_pem
  filename        = "${path.root}/keys/${var.cluster_name}-key.pem"
  file_permission = "0600"
}
