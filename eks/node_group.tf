
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.tenant_env}-${var.tenant_name}-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = ["subnet-123456", "subnet-789012"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [aws_iam_role_policy_attachment.node]
}

resource "aws_iam_role" "node" {
  name = "${var.tenant_env}-${var.tenant_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
