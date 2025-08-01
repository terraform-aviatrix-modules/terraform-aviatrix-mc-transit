module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "8.0.1"

  cloud   = "aws"
  region  = "eu-west-3"
  cidr    = "10.1.0.0/23"
  account = "AWS"
}
