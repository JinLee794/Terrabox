# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  source = "${local.module_repository}/subscription?ref=demo"
}

include {
  path = find_in_parent_folders()
}

locals {
  module_repository = "git@github.com:JinLee794/TerraBox-Modules.git//TerraBox-Modules"
}

inputs = {
  subscription_name = "ES-CE-LR-INT JINLE"
  subscription_id = "7386cd39-b109-4cc6-bb80-bf12413d0a99"
}