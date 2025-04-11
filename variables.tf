variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# For network overrides (optional)
variable "vpc_id" {
  description = "Optional custom VPC ID (overrides remote state)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Optional custom subnet IDs (overrides remote state)"
  type        = list(string)
  default     = null
}

variable "ecr_repository_name" {}

variable "create_ecr_repository" {}

variable "image_tag" {}