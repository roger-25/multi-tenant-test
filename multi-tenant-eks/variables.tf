# Required Variables (no defaults)
variable "tenant_name" {
  description = "Tenant name like chirag, roger"
  type        = string
}

variable "tenant_env" {
  description = "Environment (e.g., prod, dev, staging)"
  type        = string
  validation {
    condition     = contains(["prod", "dev", "staging", "test"], var.tenant_env)
    error_message = "Environment must be one of: prod, dev, staging, test"
  }
}

# AWS Configuration
variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of the VPC where EKS will be deployed"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster and node groups"
  type        = list(string)
  default     = []
}

# EKS Cluster Configuration
variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible"
  type        = bool
  default     = true
}

# Node Group Configuration
variable "node_instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "node_disk_size" {
  description = "Disk size (GB) for worker nodes"
  type        = number
  default     = 20
}

variable "node_scaling_config" {
  description = "Auto-scaling configuration for node groups"
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
  default = {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }
}

variable "node_capacity_type" {
  description = "Capacity type for nodes (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "Capacity type must be either ON_DEMAND or SPOT"
  }
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Add-ons Configuration
variable "enable_cluster_addons" {
  description = "Map of cluster add-ons to enable and their configurations"
  type = map(object({
    version = string
  }))
  default = {
    coredns    = { version = "v1.10.1-eksbuild.1" }
    kube-proxy = { version = "v1.28.1-eksbuild.1" }
    vpc-cni    = { version = "v1.15.0-eksbuild.1" }
  }
}