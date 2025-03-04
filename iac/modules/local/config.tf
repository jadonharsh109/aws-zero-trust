terraform {
  #   backend "s3" {
  #     bucket         = "zero-trust-tfstate"
  #     key            = "terraform.tfstate"
  #     region         = "us-west-1"
  #     encrypt        = true
  #     dynamodb_table = "tf-state-lock"
  #   } 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }

}

provider "aws" {
  region = "us-west-2"

}


