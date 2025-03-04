data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "irsa_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:default"]
    }
  }

  # Allow AWS account root to assume roles
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "read_only_role" {
  name               = "ReadOnlyAccessRole"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role_policy.json

  tags = {
    Name        = "ReadOnlyAccessRole"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_group" "read_only_group" {
  name = "${var.project_name}-Cluster-ReadOnlyAccessGroup"
}

resource "aws_iam_group_policy_attachment" "read_only_policy_attachment" {
  group      = aws_iam_group.read_only_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy" "read_only_assume_role_policy" {
  group = aws_iam_group.read_only_group.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.read_only_role.name}"
      }
    ]
  })
}

resource "aws_iam_role" "full_access_role" {
  name               = "FullAccessRole"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role_policy.json

  tags = {
    Name        = "FullAccessRole"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_group" "full_access_group" {
  name = "${var.project_name}-Cluster-FullAccessGroup"
}

resource "aws_iam_group_policy_attachment" "full_access_policy_attachment" {
  group      = aws_iam_group.full_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy" "full_access_assume_role_policy" {
  group = aws_iam_group.full_access_group.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.full_access_role.name}"
      }
    ]
  })
}
