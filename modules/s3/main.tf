resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  count = length(var.public_access_block) > 0 ? 1 : 0
  bucket = aws_s3_bucket.default.id
  block_public_acls       = try(var.public_access_block["block_public_acls"],true)
  block_public_policy     = try(var.public_access_block["block_public_policy"],true)
  ignore_public_acls      = try(var.public_access_block["ignore_public_acls"],true)
  restrict_public_buckets = try(var.public_access_block["restrict_public_buckets"],true)
}

resource "aws_s3_bucket_versioning" "default" {
  count = length(var.versioning) > 0 ? 1 : 0
  bucket = aws_s3_bucket.default.id
  versioning_configuration {
    status = try(var.versioning["enabled"] ? "Enabled" : "Suspended",false)
  }
}

resource "aws_s3_bucket_policy" "default" {
  count = length(var.statements) > 0 ? 1 : 0
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.default[count.index].json
}

data "aws_iam_policy_document" "default" {
  count = length(var.statements) > 0 ? 1 : 0  
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
      resources = [
        aws_s3_bucket.default.arn,
        "${aws_s3_bucket.default.arn}/*",
      ]
    }
  }
}
