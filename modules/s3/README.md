# AWS S3 bucket Terraform module

## Description
AWS S3 module that creates a bucket in S3, you can pass several basic values such as, the bucket name, the public access policy, enable versioning and declare a policy with different statements.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name) | (Required) Name for bucket S3 | `string` | | yes |
| <a name="input_versioning"></a> [versioning](#input_versioning) | (Optional) Set versioning S3. | `map(string)` | `{}` | no |
| <a name="input_public_access_block"></a> [public_access_block](#input_public_access_block) | (Optional) Set public access S3. | `map(bool)` | `{}` | no |
| <a name="input_statements"></a> [statements](#input_statements) | (Optional) Multiple statements for policy S3. | <code>map(object({<br>&nbsp;&nbsp;&nbsp;&nbsp;principals = map(list(string)),<br>&nbsp;&nbsp;&nbsp;&nbsp;actions    = list(string),<br>&nbsp;&nbsp;&nbsp;&nbsp;effect     = string<br>}))</code> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="otuput_arn"></a> [arn](#output_arn) | The ARN of the bucket. |
| <a name="otuput_id"></a> [id](#output_id) | The id of the bucket. |
