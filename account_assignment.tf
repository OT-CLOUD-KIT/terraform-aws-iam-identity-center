resource "aws_ssoadmin_account_assignment" "sso_account_assignment" {
  for_each           = local.account_assignment
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.sso_permission[each.value.permission_set].arn
  principal_id       = each.value.principal_type == "GROUP" ? aws_identitystore_group.sso_group[each.value.resource_name].group_id : aws_identitystore_user.sso_user[each.value.resource_name].user_id
  principal_type     = each.value.principal_type
  target_id          = each.value.target_id
  target_type        = "AWS_ACCOUNT"
}