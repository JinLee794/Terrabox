# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT GLOBAL CONFIGURATION
# Used primarily to divert the current structure of using environment vars to configure backend key
# Scenarios this is being used is to accommodate for resources that exist within a broader scope of
#   an environment (e.g Subscriptions)
# ---------------------------------------------------------------------------------------------------------------------

# Define required variable files
terraform {
  # extra_arguments "retry_lock" {
  #   commands = get_terraform_commands_that_need_locking()

  #   arguments = [
  #     "-lock-timeout=20m"
  #   ]
  # }
}

locals {
  # Load the site and environment-level shared values
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Extract the variables we need for easy access
  tenant_id = local.common_vars.locals.tenant_id

  # TODO: Do further planning on multi-tenant/region scenarios
  backend_subscription_id             = local.common_vars.locals.backend_subscription_id
  backend_storage_resource_group_name = local.common_vars.locals.backend_storage_resource_group_name
  backend_storage_account_name        = local.common_vars.locals.backend_storage_account_name

  # Load the layer-level shared values
  layer_vars = read_terragrunt_config(find_in_parent_folders("layer.hcl"))


  # Pull in Service Principal credentials from the environment
  client_secret = get_env("ARM_CLIENT_SECRET")
}

# Generate an Azure provider block
# TODO: Do further planning on multi-tenant/region scenarios around multiple provider configurations
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Blob Storage container


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_vars.locals,
  local.layer_vars.locals,
  {
    client_secret = local.client_secret
  }
)