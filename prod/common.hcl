locals {
  tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"

  # Backend Remote State Provider for prod subscriptions
  backend_subscription_id             = "7386cd39-b109-4cc6-bb80-bf12413d0a99"
  backend_storage_account_name        = "bootstrapsadev"
  backend_storage_resource_group_name = "bootstrap"

  module_repository         = "git::git@github.com:JinLee794/TerraBox-Modules.git"
  module_repository_version = "demo"
}


// https://raw.githubusercontent.com/JinLee794/TerraBox-Modules/main/key-vault/main.tf