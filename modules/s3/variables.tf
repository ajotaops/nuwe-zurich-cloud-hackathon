variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "versioning" {
  description = "Versioning options"
  type        = map(string)
  default     = {}
}

variable "public_access_block" {
  description = "Public Access options S3"
  type        = map(bool)
  default     = {}
}

variable "statements" {
  description = "Statements for S3 AWS"
  type = map(object({
    principals = map(list(string))
    actions    = list(string)
    effect     = string
  }))
  default = {}
}
