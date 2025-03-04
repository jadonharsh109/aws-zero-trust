# Purpose: Create an EKS cluster with managed node groups.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.eks_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_cidrs

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # Node Group Configuration
  eks_managed_node_groups = {
    secure_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["m5.large"]
      capacity_type  = "SPOT"

      # Least-privilege IAM role
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  # Cluster Security Group
  cluster_security_group_additional_rules = {
    ingress_nodes_443 = {
      description                = "Node groups to cluster API"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  tags = {
    Name        = lower("${var.project_name}-cluster")
    Environment = var.environment
    Project     = var.project_name
  }
}

# Generate kubeconfig file for the EKS cluster
resource "null_resource" "generate_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
  }
  depends_on = [module.eks]
}





