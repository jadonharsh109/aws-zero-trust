# variables.tf
variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "zero-trust-cluster"
}

variable "config_filename" {
  description = "Filename of the Kind cluster configuration in the current directory"
  type        = string
  default     = "kind-config.yaml"
}
