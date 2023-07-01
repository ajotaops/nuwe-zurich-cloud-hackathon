variable "role" {
  description = "IAM role name"
  type        = string
}

variable "instance_profile" {
  description = "Create instance profile"
  type = bool
  default = false
}

variable "statements" {
  description = "Statements for IAM trust policy"
  type = map(object({
    principals = map(list(string))
    actions    = list(string)
    effect     = string
  }))
}