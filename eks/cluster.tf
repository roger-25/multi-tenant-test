resource "aws_eks_cluster" "this" {
  count    = var.create_cluster ? 1 : 0
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name        = var.cluster_name
    Tenant      = var.tenant_name
    Environment = var.tenant_env
  }
}
