locals {
  tenant_id           = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  management_group_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"

  backend_storage_account_name        = "bootstrapsadev"
  backend_storage_resource_group_name = "bootstrap"

  env = "dev"

  mock_values = {
    "resource-group" = {
      name     = "bootstrap"
      location = "East US 2"
      tags     = {}
    }
  }
}