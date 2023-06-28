
resource "aws_ssoadmin_permission_set" "sso_permission" {
  for_each         = var.permission_sets != null ? var.permission_sets : {}
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  name             = each.key
  description      = each.value.description
  relay_state      = each.value.relay_state
  session_duration = each.value.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "sso_inline_permission" {
  for_each           = local.inline_policy
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  inline_policy      = file("inline-policy/${each.key}.json")
  permission_set_arn = aws_ssoadmin_permission_set.sso_permission[each.key].arn
}

resource "aws_ssoadmin_managed_policy_attachment" "sso_managed_permission" {
  for_each           = local.managed_policy
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  managed_policy_arn = each.value.policy
  permission_set_arn = aws_ssoadmin_permission_set.sso_permission[each.value.permission_set_name].arn
}