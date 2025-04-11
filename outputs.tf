output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "tfvars_s3_location" {
  value = aws_s3_object.tfvars.id
}