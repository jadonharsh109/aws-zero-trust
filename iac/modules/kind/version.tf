# versions.tf
terraform {
  required_version = ">= 0.14.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}
