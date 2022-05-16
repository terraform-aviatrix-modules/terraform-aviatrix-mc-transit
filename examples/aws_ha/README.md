### Usage Example AWS HA

In this example, the module deploys the transit VPC as well as a HA pair of Aviatrix transit gateways.

```
module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.4"

  cloud         = "aws"
  region        = "eu-west-3"
  cidr          = "10.1.0.0/23"
  account       = "AWS"
}
```