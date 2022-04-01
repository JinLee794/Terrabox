locals {
    resource_group_name = "vm-extensions-sandbox" 
    nic_resource_group_name = "vm-extensions-sandbox-nic" 
    location = "eastus"
    tags = {}
    admin_username = "jleeadmin"
    admin_password_secret_name = "win-sandbox-admin"
    subnet_id="/subscriptions/7386cd39-b109-4cc6-bb80-bf12413d0a99/resourceGroups/HubNetworkdevrg/providers/Microsoft.Network/virtualNetworks/hub/subnets/WinVMPrivateSubnet"
    law_id = "9aa65e21-29c8-44ec-aa57-0811a4a90dfe"
    law_key_vault_name = "bootstrap-iac-kv"
    law_key_vault_resource_group_name = "bootstrap"
    law_key_name= "sandbox-law-win-primary-key"
}