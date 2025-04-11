
# Get data about EXISTING cluster instead of creating new
data "aws_eks_cluster" "existing" {
  name = "${var.tenant_env}-${var.tenant_name}-eks" # Must match exact existing name
}

data "aws_eks_cluster_auth" "existing" {
  name = "${var.tenant_env}-${var.tenant_name}-eks"
}

# Keep IAM role if needed for other operations
resource "aws_iam_role" "eks" {
  count = 0 # Disable creation since cluster exists
  # ... (keep as backup reference) ...
}

# Kubernetes provider config using existing cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.existing.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.existing.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.existing.token
}