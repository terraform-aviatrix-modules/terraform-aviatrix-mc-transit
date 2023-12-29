### Usage Example AWS Non-HA

In this example, the module deploys the transit VPC as well as a single Aviatrix transit gateway.

```hcl
module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.3.4"

  cloud         = "aws"
  region        = "eu-west-3"
  cidr          = "10.1.0.0/23"
  account       = "AWS"
  ha_gw         = false
}
```