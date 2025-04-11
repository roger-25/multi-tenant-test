resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.test.name
  node_group_name = "${var.tenant_env}-${var.tenant_name}-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets  # Reference from VPC module

  # Instance configuration
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  disk_size      = 20

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  # Kubernetes labels
  labels = {
    Environment = var.tenant_env
    Tenant      = var.tenant_name
  }

  # Ensure all required IAM policies are attached first
  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_cni
  ]
}

# IAM role with all required policies
resource "aws_iam_role" "node" {
  name = "${var.tenant_env}-${var.tenant_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach all required policies
resource "aws_iam_role_policy_attachment" "node_worker" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}