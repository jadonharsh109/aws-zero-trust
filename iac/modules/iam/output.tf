output "readonly_role_arn" {
  value = aws_iam_role.read_only_role.arn
}

output "fullaccess_role_arn" {
  value = aws_iam_role.full_access_role.arn
}
