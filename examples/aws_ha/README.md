### Usage Example AWS HA

In this example, the module deploys the transit VPC as well as a HA pair of Aviatrix transit gateways.

```
module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.0.0"

  cloud         = "aws"
  region        = "eu-west-3"
  cidr          = "192.168.90.0/23"
  account       = "AWS"
}
```