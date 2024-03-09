output "endpoint" {
  value = aws_eks_cluster.nexasphere-eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.nexasphere-eks.certificate_authority[0].data
}