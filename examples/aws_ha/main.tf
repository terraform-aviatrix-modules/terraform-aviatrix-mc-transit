module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.3.3"

  cloud   = "aws"
  region  = "eu-west-3"
  cidr    = "10.1.0.0/23"
  account = "AWS"
}