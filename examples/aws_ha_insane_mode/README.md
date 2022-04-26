### Usage Example AWS HA + Insane Mode

In this example, the module deploys the transit VPC as well as a HA pair of Aviatrix transit gateways with insane_mode enabled.

```
module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.0.2"

  cloud         = "aws"
  region        = "eu-west-3"
  cidr          = "10.1.0.0/23"
  account       = "AWS"
  insane_mode   = true
  instance_size = "c5n.large" #Non-default value required, as minimum instance size for Insane Mode is c5.large
}
```