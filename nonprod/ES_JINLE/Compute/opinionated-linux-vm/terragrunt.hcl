# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  source = "${local.module_repository}//Azure/linux-virtual-machine?ref=${local.module_repository_version}"
  // source = "${local.module_repository}//Azure/linux-virtual-machine"
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
  env_vars                  = read_terragrunt_config(find_in_parent_folders("${local.env}.hcl"))

  layer_vars = read_terragrunt_config(find_in_parent_folders("layer.hcl"))

  env      = get_env("ENV", "dev")
  env_tags = local.env_vars.locals.tags
}

inputs = {
  name    = "OpinionatedVM"
  vm_name = "optumtestvm1"

  # Vars to avoid hardcoded secrets
  key_vault_name                = local.layer_vars.locals.law_key_vault_name
  key_vault_resource_group_name = local.layer_vars.locals.law_key_vault_resource_group_name
  ssh_public_key_name           = "aks-dev-ssh-public-key"

  # Vars with validation
  size = "Standard_Dsv3"
  tags = {
    BusinessUnit        = "CoreIT"
    OperationsTeam      = "MyOpsTeam@contoso.com"
    BusinessCriticality = "Low"
    DataClassification  = "Public"
    WorkloadName        = "TerraformOpinionatedVM"
  }
  // env = "thiswillerror" // This should cause an error


  # To get a list of marketplace images: $ az vm image list --output table
  source_image_reference = {
    publisher = "OpenLogic"
    offer     = "CentOs"
    sku       = "7.5"
    version   = "latest"
  }
}
