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
  managed_policy = { for permission_set_name, policy in var.permission_sets :
    permission_set_name => policy.managed_policy_arn
    if(policy.managed_policy_arn != "")
  }

  inline_policy = { for permission_set_name, policy in var.permission_sets :
    permission_set_name => fileexists("${path.root}/inline-policy/${permission_set_name}.json")
    if fileexists("${path.root}/inline-policy/${permission_set_name}.json")
  }
}

