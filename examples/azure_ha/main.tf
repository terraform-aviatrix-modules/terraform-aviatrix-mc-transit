module "azure_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "8.0.1"

  cloud   = "azure"
  region  = "West Europe"
  cidr    = "10.1.0.0/23"
  account = "Azure"
}