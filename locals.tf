locals {
  group_members = flatten([for group_name, members_name in var.groups_identity : flatten([
    for user_info in members_name.usernames :
    merge({
      group_name = group_name,
      username   = user_info,
      key        = join("_", [group_name], [user_info])
    })
    ])

  ])
  users_assign_group = { for index, user_info in local.group_members : user_info.key => user_info }
}

locals {
  local_managed_policy = flatten([for permission_set_name, policies in var.permission_sets :
    flatten([for policy in policies.managed_policy_arns :
      merge({
        policy              = policy,
        permission_set_name = permission_set_name
        key                 = join(": ", [permission_set_name], [policy])
      })
    ])
  ])
  managed_policy = { for key, policy in local.local_managed_policy : policy.key => policy }


  inline_policy = { for permission_set_name, policy in var.permission_sets :
    permission_set_name => fileexists("${path.root}/inline-policy/${permission_set_name}.json")
    if fileexists("${path.root}/inline-policy/${permission_set_name}.json")
  }
}

locals {
  local_account_assignment = flatten([for key, value in var.account_assignment :
    flatten([for targets in value.targets_id :
      merge({
        key            = join(": ", [key], [targets])
        target_id      = targets
        permission_set = value.permission_set
        principal_type = value.principal_type
        resource_name  = value.resource_name
      })
    ])
  ])
  account_assignment = { for targets in local.local_account_assignment : targets.key => targets }
}

