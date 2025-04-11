resource "aws_eks_node_group" "this" {
  count           = var.create_cluster ? 1 : 0
  cluster_name    = aws_eks_cluster.this[0].name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name        = "${var.cluster_name}-ng"
    Tenant      = var.tenant_name
    Environment = var.tenant_env
  }
}
