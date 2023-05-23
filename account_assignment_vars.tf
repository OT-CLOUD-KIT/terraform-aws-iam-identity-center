variable "account_assignment" {
  type = map(object({
    principal_type = string
    target_id      = string
    permission_set = string
    resource_name  = string
  }))
  default = {}
}