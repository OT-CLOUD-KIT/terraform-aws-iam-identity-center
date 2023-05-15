data "aws_ssoadmin_instances" "sso" {}

resource "aws_identitystore_user" "sso_user" {
  for_each          = var.users_identity != null ? var.users_identity : {}
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  display_name      = each.value.display_name != null ? each.value.display_name : "${each.value.first_name} ${each.value.last_name}"
  user_name         = each.key

  name {
    family_name = each.value.last_name
    given_name  = each.value.first_name
    middle_name = each.value.middle_name
  }

  emails {
    value   = each.value.email_id.value
    primary = each.value.email_id.primary
    type    = each.value.email_id.type
  }

  addresses {
    country        = each.value.address.country
    locality       = each.value.address.locality
    postal_code    = each.value.address.postal_code
    primary        = each.value.address.primary
    region         = each.value.address.region
    street_address = each.value.address.street_address
    type           = each.value.address.type
  }

  phone_numbers {
    value   = each.value.phone_number.value
    primary = each.value.phone_number.primary
    type    = each.value.phone_number.type
  }
}

resource "aws_identitystore_group" "sso_group" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  for_each          = var.groups_identity != null ? var.groups_identity : {}
  display_name      = each.key
  description       = each.value.description
}

resource "aws_identitystore_group_membership" "user_allocation" {
  for_each          = local.users_assign_group != null ? local.users_assign_group : {}
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  group_id          = aws_identitystore_group.sso_group[each.value.group_name].group_id
  member_id         = aws_identitystore_user.sso_user[each.value.username].user_id
}




