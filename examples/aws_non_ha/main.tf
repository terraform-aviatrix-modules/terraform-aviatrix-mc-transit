module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.4"

  cloud   = "aws"
  region  = "eu-west-3"
  cidr    = "10.1.0.0/23"
  account = "AWS"
  ha_gw   = false
}