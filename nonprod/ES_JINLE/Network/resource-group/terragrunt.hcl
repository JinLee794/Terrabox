# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  # source = "${local.module_repository}//key-vault?ref=${local.module_repository_version}"
  source = "${local.module_repository}//resource-group?ref=${local.module_repository_version}"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars               = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  module_repository         = local.common_vars.locals.module_repository
  module_repository_version = local.common_vars.locals.module_repository_version

  layer_vars = read_terragrunt_config(find_in_parent_folders("layer.hcl"))
  layer_name = local.layer_vars.locals.layer_name

  env = get_env("ENV", "dev")
}

inputs = {
  resource_group_name = "${local.layer_name}${local.env}rg"
}
