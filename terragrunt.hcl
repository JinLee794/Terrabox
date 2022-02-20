# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Define required variable files
terraform {
  extra_arguments "retry_lock" {
    commands = get_terraform_commands_that_need_locking()

    arguments = [
      "-lock-timeout=20m"
    ]
  }
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

  # Extract the ENV value from the environment; default to dev
  env      = get_env("ENV", "dev")
  env_vars = read_terragrunt_config(find_in_parent_folders("${local.env}.hcl"))

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
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    subscription_id      = local.backend_subscription_id
    resource_group_name  = local.backend_storage_resource_group_name
    storage_account_name = local.backend_storage_account_name
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/${local.env}/terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_vars.locals,
  local.env_vars.locals,
  {
    client_secret = local.client_secret
  }
)