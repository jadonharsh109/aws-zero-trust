variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "zero-trust-network"
}

variable "environment" {
  description = "The environment of the project"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
  default     = "us-west-2"
}
