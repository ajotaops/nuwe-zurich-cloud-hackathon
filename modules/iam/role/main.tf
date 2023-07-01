resource "aws_iam_role" "default" {
  name = var.role
  assume_role_policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_instance_profile" "default" {
  count = var.instance_profile ? 1 : 0
  name = "${resource.aws_iam_role.default.name}-InstanceProfile"
  role = aws_iam_role.default.name
}

data "aws_iam_policy_document" "default" {
  dynamic statement {
    for_each = var.statements
    content {
      dynamic principals {
        for_each = statement.value.principals
        content {
          type        = principals.key
          identifiers = principals.value 
        }
      }
      sid = statement.key
      actions = statement.value.actions
      effect = statement.value.effect
    }
  }
}