module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.3.4"

  cloud       = "aws"
  region      = "eu-west-3"
  cidr        = "10.1.0.0/23"
  account     = "AWS"
  insane_mode = true
}
