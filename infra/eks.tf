resource "aws_eks_cluster" "nexasphere-eks" {
  name     = "nexasphere-k8s"
  role_arn = aws_iam_role.nexasphere-root.arn

  vpc_config {
    subnet_ids             = [for s in var.list_eks : aws_subnet.nexasphere-nodes-subnet[s].id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_subnet.nexasphere-nodes-subnet,
    aws_iam_role.nexasphere-root
  ]
}

resource "aws_eks_node_group" "nexasphere-nodes" {
  cluster_name    = aws_eks_cluster.nexasphere-eks.name
  node_group_name = "nexasphere-nodes"
  node_role_arn   = aws_iam_role.nexasphere-node-manager.arn
  subnet_ids      = [for s in var.list_nodes : aws_subnet.nexasphere-nodes-subnet[s].id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type  = "AL2_x86_64"
  instance_types = ["t3.medium"]

  force_update_version = true

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_subnet.nexasphere-nodes-subnet,
    aws_iam_role.nexasphere-node-manager
  ]
}
