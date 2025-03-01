# Module for creating a Virtual Private Cloud (VPC) in AWS
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "5.5.1"

  name = lower("${var.project_name}-vpc")

  cidr = var.vpc_cidr

  azs = var.availability_zones

  private_subnets = var.private_subnet_cidrs

  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway

  single_nat_gateway = var.single_nat_gateway

  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames = var.enable_dns_hostnames

  enable_dns_support = var.enable_dns_support

  tags = {
    Name        = lower("${var.project_name}-vpc")
    Environment = var.environment
    Project     = var.project_name
  }
}
