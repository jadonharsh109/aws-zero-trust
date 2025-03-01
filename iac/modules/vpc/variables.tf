variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment of the project"
  type        = string
}

variable "region" {
  description = "The region of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones for the VPC"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "Use one NAT Gateway per availability zone"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
}
