variable "region" {
  type = string
}
variable "tenant_name" {
  type = string
}
variable "tenant_env" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
