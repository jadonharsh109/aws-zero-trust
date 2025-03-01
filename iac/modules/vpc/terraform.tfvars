project_name = "zero-trust-network"

environment = "dev"

region = "us-west-2"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

availability_zones = ["us-west-2a", "us-west-2b"]

enable_nat_gateway = true

single_nat_gateway = true

one_nat_gateway_per_az = false

enable_dns_hostnames = true

enable_dns_support = true
