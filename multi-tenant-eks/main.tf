
provider "aws" {
  region = var.region
}

module "eks" {
  source       = "./eks"
  tenant_name  = var.tenant_name
  tenant_env   = var.tenant_env
  region       = var.region
}

