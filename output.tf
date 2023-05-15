output "sso_groups" {
  value = aws_identitystore_group.sso_group
}

output "sso_users" {
  value = aws_identitystore_user.sso_user
}