variable "readonly_role_arn" {
  type        = string
  description = "The ARN of the IAM role to be assigned to the readonly group"
}

variable "fullaccess_role_arn" {
  type        = string
  description = "The ARN of the IAM role to be assigned to the fullaccess group"
}
