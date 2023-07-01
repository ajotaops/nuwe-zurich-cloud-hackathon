output "arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.default.arn
}

output "id" {
  description = "The id of the bucket"
  value       = aws_s3_bucket.default.id
}