terraform {
  backend "s3" {
    bucket         = "multi-tenant-users"
    key            = "terraform-state/${terraform.workspace}/eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "multi-tenant-db"
  }
}

provider "aws" {
  region = var.region
}

module "eks" {
  source       = "./eks"
  tenant_name  = var.tenant_name
  tenant_env   = var.tenant_env
  region       = var.region
}