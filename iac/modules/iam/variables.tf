variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "oidc_provider" {
  description = "The OIDC provider URL"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The OIDC provider ARN"
  type        = string
}

variable "environment" {
  description = "The environment"
  type        = string
}
