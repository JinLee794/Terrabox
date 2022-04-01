# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # source = "${local.module_repository}//key-vault?ref=${local.module_repository_version}"
  source = "${local.module_repository}//service-principal?ref=${local.module_repository_version}"
}

include {
  path = find_in_parent_folders()
}

dependency "subscription" {
  config_path = "../../../Network/resource-group"
}

locals {
  common_vars               = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  module_repository         = local.common_vars.locals.module_repository
  module_repository_version = local.common_vars.locals.module_repository_version

  layer_vars = read_terragrunt_config(find_in_parent_folders("layer.hcl"))
  app_name   = local.layer_vars.locals.app_name
  env        = get_env("ENV", "dev")
}

inputs = {
  display_name = "Network-${local.env}-Contributor"
  scope        = dependency.subscription.outputs.id

  actions = [
    "*"
  ]
  not_actions = []
}
