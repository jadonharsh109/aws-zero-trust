variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment of the project"
  type        = string
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "eks_version" {
  description = "The version of EKS to use"
  type        = string
}
