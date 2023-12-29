module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "transit-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]
}

module "aws_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.4.3"

  cloud   = "aws"
  region  = "eu-central-1"
  account = "AWS"

  use_existing_vpc = true
  vpc_id           = module.vpc.vpc_id
  gw_subnet        = module.vpc.public_subnets_cidr_blocks[0]
  hagw_subnet      = module.vpc.public_subnets_cidr_blocks[1]
}
