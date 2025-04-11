provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "multi-tenant-state"
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

module "eks" {
  source        = "./eks"
  tenant_name   = var.tenant_name
  tenant_env    = var.tenant_env
  cluster_name  = var.cluster_name
  region        = var.region
  vpc_id        = var.vpc_id
  subnet_ids    = var.subnet_ids
  create_cluster = var.create_cluster
}
