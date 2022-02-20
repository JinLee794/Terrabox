# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  #   source = "${include.envcommon.locals.base_source_url}?ref=v0.4.0"
  source = "${include.envcommon.locals.base_source_url}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------
dependency "resource-group" {
  config_path                             = "../resource-group"
  mock_outputs                            = local.mock_values
  mock_outputs_allowed_terraform_commands = ["apply", "plan", "destroy", "output"]
}

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
# include "envcommon" {
#   path   = "${dirname(find_in_parent_folders())}/_common/virtual-networks.hcl"
#   expose = true
# }

locals {
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))
  mock_values       = local.subscription_vars.locals.mock_values
}

inputs = {
  vnet_name     = "hub"
  address_space = ["10.0.0.0/24"]

  subnets = {
    AzureFirewallSubnet = "10.0.0.0/26"
    SharedServices      = "10.0.0.64/26"
    AzureBastionSubnet  = "10.0.0.192/27"
    GatewaySubnet       = "10.0.0.224/27"
  }

  resource_group_name = dependency.resource-group.outputs.name
  location            = dependency.resource-group.outputs.location
  tags = merge(
    {
      "Application Name" : "Super Cool App",
      "Disaster Recovery" : "Essential"
    },
  dependency.resource-group.outputs.tags)
}