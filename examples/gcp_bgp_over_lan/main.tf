module "transit_gcp_for_ncc" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "8.0.1"

  cloud           = "gcp"
  name            = "transit-gcp-for-ncc"
  instance_size   = "n2-highcpu-4" #3 interfaces needed.
  region          = "us-east1"
  cidr            = "10.1.0.0/23"
  account         = "GCP"
  local_as_number = 65101

  enable_bgp_over_lan = true

  bgp_lan_interfaces = [{
    subnet = "10.44.254.32/28" # VPC/Subnet created.
    },
    {
      vpc_id = "avx-mgmt",
      subnet = "10.40.254.32/28" # VPC/Subnet already exists.
  }]

  ha_bgp_lan_interfaces = [{
    subnet = "10.44.254.32/28" # VPC/Subnet created.
    },
    {
      vpc_id = "avx-mgmt",
      subnet = "10.40.254.32/28" # VPC/Subnet already exists.
  }]
}
