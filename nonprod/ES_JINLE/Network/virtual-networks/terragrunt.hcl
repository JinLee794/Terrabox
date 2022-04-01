# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  source = "${local.module_repository}//virtual-network?ref=${local.module_repository_version}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------
dependency "resource-group" {
  config_path = "../resource-group"
}

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders()
}


locals {
  common_vars               = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  module_repository         = local.common_vars.locals.module_repository
  module_repository_version = local.common_vars.locals.module_repository_version

  env_vars = read_terragrunt_config(find_in_parent_folders("${local.env}.hcl"))

  env      = get_env("ENV", "dev")
  env_tags = local.env_vars.locals.tags
}

inputs = {
  vnet_name = "${local.env}-hub-vnet"

  resource_group_name = dependency.resource-group.outputs.name
  location            = dependency.resource-group.outputs.location
  tags = merge(
    {
      "VNetComponent" : "Hub",
      "Disaster Recovery" : "Essential"
    },
  local.env_tags)
}
