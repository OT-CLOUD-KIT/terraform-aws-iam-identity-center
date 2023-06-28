variable "permission_sets" {
  type = map(object({
    description         = optional(string)
    relay_state         = optional(string)
    session_duration    = optional(string, "PT1H")
    managed_policy_arns = optional(list(string), [])
  }))
  default = {}
}