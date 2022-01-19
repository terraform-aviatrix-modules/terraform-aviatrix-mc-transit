### Usage Example Azure HA

In this example, the module deploys the transit VNET as well as a HA pair of Aviatrix transit gateways.

```
module "azure_transit" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.0.0"

  cloud   = "azure"
  region  = "West Europe"
  cidr    = "10.1.0.0/23"
  account = "Azure"
}
```