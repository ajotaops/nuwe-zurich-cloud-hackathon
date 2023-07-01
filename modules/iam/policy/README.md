# AWS IAM policy Terraform module

## Description
AWS module that creates an IAM policy, with the possibility to create multiple statements and to attach to many roles.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="name"></a> [name](#name) | (Required) Name for policy. | `string` | | yes |
| <a name="description"></a> [description](#description) | (Optional) Description for policy | `string` | `""` | no |
| <a name="version_policy"></a> [version_policy](#version_policy) | (Optional) Version policy | `string` | `"2012-10-17"` | no |
| <a name="roles"></a> [roles](#roles) | (Optional) Set of roles to attach policy | `set(string)` | `[]` | no |
| <a name="input_statements"></a> [statements](#input_statements) | (Required) Multiple statements for policy. | <code>map(object({<br>&nbsp;&nbsp;&nbsp;&nbsp;Resources    = list(string),<br>&nbsp;&nbsp;&nbsp;&nbsp;Action    = list(string),<br>&nbsp;&nbsp;&nbsp;&nbsp;Effect     = string<br>}))</code> | | yes |
