variable "users_identity" {
  type = map(object({
    first_name   = string
    last_name    = optional(string)
    display_name = optional(string)
    middle_name  = optional(string)
    email_id = object({
      value   = optional(string)
      primary = optional(bool)
      type    = optional(string)
    })
    address = object({
      country        = optional(string)
      locality       = optional(string)
      postal_code    = optional(number)
      primary        = optional(bool)
      region         = optional(string)
      street_address = optional(string)
      type           = optional(string)
    })
    phone_number = object({
      value   = optional(number)
      primary = optional(bool)
      type    = optional(string)
    })
  }))
  default     = {}
  description = "Users detail for Identity center(SSO)"
}

variable "groups_identity" {
  type = map(object({
    usernames   = optional(list(string), [])
    description = optional(string, null)
  }))
  default = {}
}

