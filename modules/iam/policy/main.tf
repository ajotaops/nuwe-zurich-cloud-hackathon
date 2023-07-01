resource "aws_iam_policy" "default" {
  name        = var.name
  description = var.description

  policy = jsonencode({
    Version = var.version_policy
    Statement = var.statements
  })
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = var.roles
  role       = each.value
  policy_arn = aws_iam_policy.default.arn
}