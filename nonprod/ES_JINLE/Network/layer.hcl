locals {
  layer_name    = "HubNetwork"
  address_space = ["10.0.0.0/24"]

  subnets = {
    AzureFirewallSubnet = "10.0.0.0/26"
    SharedServices      = "10.0.0.64/26"
    AzureBastionSubnet  = "10.0.0.192/27"
    GatewaySubnet       = "10.0.0.224/27"
  }
  location = "East US"
}
