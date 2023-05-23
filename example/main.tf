provider "aws" {
  region = "us-east-1"
}

module "sso_user_group" {
  source             = "../modules/identity_store"
  users_identity     = var.users_identity
  groups_identity    = var.groups_identity
  permission_sets    = var.permission_set
  account_assignment = var.account_assignment
}