locals {
  layer_name = "bastion"
  subnets = {
    AzureBastionSubnet = "10.0.0.0/26"
    WinVMSubnet        = "10.0.0.64/26"
    BastionVMSubnet    = "10.0.0.128/28"
  }
  location = "East US"
}
