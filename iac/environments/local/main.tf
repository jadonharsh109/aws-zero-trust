module "kind_cluster" {
  source = "../../modules/kind"

  # Just specify the cluster name
  cluster_name = "zero-trust-cluster"

  # Optionally specify a different filename if not using the default
  # config_filename = "custom-config.yaml"
}
