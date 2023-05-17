# IAM identity center
[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

This terraform module will help users to setup:
- Users for SSO
- Groups in identity center
- Attach users to group 
- Permission set
- Give user/group access to account with permission set
## Prerequisites
- AWS access of root account/management account of control tower with admin privilege
- Terraform >= 1.3.0
- AWS CLI
## Providers
AWS
## Inputs
| Name | Description | Type | Default | Required |
|-------|----------|------|-----|-----|
|users_identity|User related information such as username, firstname, lastname, email-id etc|map(object)| null | no |
|groups_identity|Group related information such as groupname, username, description | map(object) | null | no
| permission_sets | Permission for accessing AWS resources you can use managed policy or inline policy | map(object) | null | no
|account_assignment|Allow user/group to access account with permission set| map(object)| null | no |

## Outputs
| Name | Description |
|------|-------------|
|sso_users|About users which is created by TF|
|sso_groups| About groups which is created by TF

## Usage
```hcl
module "sso_user_group" {
  source             = "../modules/identity_store"
  users_identity     = var.users_identity
  groups_identity    = var.groups_identity
  permission_sets    = var.permission_set
  account_assignment = var.account_assignment
}

# Variables
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

variable "permission_set" {
  type = map(object({
    description        = optional(string)
    relay_state        = optional(string)
    session_duration   = optional(string, "PT1H")
    managed_policy_arn = optional(string, null)
  }))
  default = {}
}

variable "account_assignment" {
  type = map(object({
    principal_type = string
    target_id      = string
    permission_set = string
    resource_name  = string
  }))
  default = {}
}
```

### Contributors
[Ashutosh Yadav](https://github.com/ashutoshyadav66)
