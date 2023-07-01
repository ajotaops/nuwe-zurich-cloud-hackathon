variable "name" {
  description = "Policy name"
  type        = string
}

variable "description" {
  description = "Policy description"
  type        = string
  default     = ""
}

variable "version_policy" {
  description = "Policy version"
  type        = string
  default = "2012-10-17"
}

variable "statements" {
  description = "Policy Statements"
    type = list(object({
    Action   = list(string)
    Effect   = string
    Resource = list(string)
  }))
}

variable "roles" {
  description = "List of roles to attach policy"
  type = set(string)
  default = []
}