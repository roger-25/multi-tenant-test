terraform {
  backend "s3" {
    bucket         = "multi-tenant-users"
    key            = "terraform-state/${terraform.workspace}/eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "multi-tenant-db"
    encrypt = true
  }
}