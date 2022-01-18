### Usage Example AWS Non-HA

In this example, the module deploys the transit VPC as well as a single Aviatrix transit gateway.

```
module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.0.0"

  cloud         = "aws"
  region        = "eu-west-3"
  cidr          = "192.168.90.0/23"
  account       = "Primary_acc"
  ha_gw         = false
}
```