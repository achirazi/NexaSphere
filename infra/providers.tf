provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""
}


# provider "kubernetes" {
#   host                   = aws_eks_cluster.nexasphere-eks.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.nexasphere-eks.certificate_authority[0].data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name",  aws_eks_cluster.nexasphere-eks.name]
#   }
# }