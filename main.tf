data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "multi-tenant-state"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "eks" {
  source       = "./eks"
  tenant_name  = var.tenant_name
  tenant_env   = var.tenant_env
  cluster_name = var.cluster_name
  region       = var.region
  vpc_id       = try(var.vpc_id, data.terraform_remote_state.network.outputs.vpc_id)
  subnet_ids   = try(var.subnet_ids, data.terraform_remote_state.network.outputs.subnet_ids)

  providers = {
    aws = aws
  }

  count = var.create_cluster ? 1 : 0
}

locals {
  existing_content = fileexists(var.existing_tfvars_path) ? file(var.existing_tfvars_path) : ""
  new_content      = <<EOT
${local.existing_content}
tenant_name = "${var.tenant_name}"
tenant_env = "${var.tenant_env}"
username = "${var.username}"
EOT
}

resource "local_file" "new_tfvars" {
  filename = var.new_tfvars_name
  content  = local.new_content
}

resource "aws_s3_object" "tfvars" {
  bucket = var.s3_bucket
  key    = "terraform/vars/${var.tenant_name}/${var.tenant_env}/${var.new_tfvars_name}"
  source = local_file.new_tfvars.filename
  etag   = filemd5(local_file.new_tfvars.filename)
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
