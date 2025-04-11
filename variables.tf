variable "cluster_name" {}

variable "region" {}

# For network overrides (optional)
variable "vpc_id" {}

variable "subnet_ids" {}

variable "ecr_repository_name" {}
variable "image_tag" {}

variable "tenant_name" {}

variable "tenant_env" {}

variable "create_cluster" {
  type    = bool
  default = true
}
