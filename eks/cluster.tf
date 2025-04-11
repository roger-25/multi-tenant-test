
resource "aws_eks_cluster" "this" {
  name     = "${var.tenant_env}-${var.tenant_name}-eks"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = ["subnet-008b9af164b3b7a4b", "subnet-092498bd69dd868bc"]
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

resource "aws_iam_role" "eks" {
  name = "${var.tenant_env}-${var.tenant_name}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
