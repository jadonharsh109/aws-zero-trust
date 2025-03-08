module "vpc" {
  source = "../../modules/vpc"

  project_name           = var.project_name
  environment            = var.environment
  region                 = var.region
  vpc_cidr               = "10.0.0.0/16"
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs   = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones     = ["us-west-2a", "us-west-2b"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
}

module "eks" {
  source = "../../modules/eks"

  project_name         = var.project_name
  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = module.vpc.private_subnets_cidr_blocks
  eks_version          = "1.32"
  region               = var.region

}

module "iam" {
  source = "../../modules/iam"

  project_name      = var.project_name
  environment       = var.environment
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider

}

module "eks-auth" {
  source = "../../modules/eks-auth"

  readonly_role_arn   = module.iam.readonly_role_arn
  fullaccess_role_arn = module.iam.fullaccess_role_arn
}

