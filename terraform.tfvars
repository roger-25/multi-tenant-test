tenant_name = "array"
tenant_env  = "prod"
region      = "us-east-1"

node_instance_types = ["t3.medium", "t3.large"]
node_capacity_type  = "SPOT"

tags = {
  Project     = "Multi-Tenant-EKS"
  ManagedBy   = "Terraform"
  Environment = "production"
}