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
  default = {
    "example1@gmail.com" = {
      first_name   = ""
      last_name    = ""
      phone_number = {}
      address      = {}
      email_id = {
        value   = "example1@gmail.com"
        primary = false
        type    = "work"
      }
    }
    "example2@gmail.com" = {
      first_name   = ""
      last_name    = ""
      phone_number = {}
      address      = {}
      email_id     = {}
    }
  }
  description = "Users detail for Identity center(SSO)"
}

variable "groups_identity" {
  type = map(object({
    usernames   = optional(list(string), [])
    description = optional(string, null)
  }))
  default = {
    "DevopsBasic" = {
      usernames = [
        "example1@gmail.com",
        "example2@gmail.com"
      ]
      description = "Group for ReadOnly Users"
    }
    "DevopsReadonly" = {
      usernames = [
        "example1@gmail.com",
        "example2@gmail.com"
      ]
      description = "Group for Users having basic type of permissions"
    }
  }
}

variable "permission_set" {
  type = map(object({
    description         = optional(string)
    relay_state         = optional(string)
    session_duration    = optional(string, "PT1H")
    managed_policy_arns = optional(list(string), null)
  }))
  default = {
    "DevopsReadOnly" = {
      description         = "Devops readonly permission policy"
      managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
    "CustomReadOnly" = {
      description = "Custom readonly which will read from file in inline policy directory, file name must be same as permission-set name"
    }
  }
}

variable "account_assignment" {
  type = map(object({
    principal_type = string
    targets_id     = list(string)
    permission_set = string
    resource_name  = string
  }))
  default = {
    "ReadOnlyForReadGroup" = {
      principal_type = "GROUP"
      targets_id     = ["123456789"]
      permission_set = "DevopsReadOnly"
      resource_name  = "DevopsBasic"
    }
    "AdminDevopForPWDev" = {
      principal_type = "USER"
      targets_id     = ["987654321"]
      permission_set = "CustomReadOnly"
      resource_name  = "example1@gmail.com"
    }
  }
}
