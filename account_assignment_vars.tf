variable "account_assignment" {
  type = map(object({
    principal_type = string
    targets_id     = list(string)
    permission_set = string
    resource_name  = string
  }))
  default = {}
}