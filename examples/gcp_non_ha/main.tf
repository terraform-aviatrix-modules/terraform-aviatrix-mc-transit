module "transit_non_ha_gcp" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "8.0.1"

  cloud   = "gcp"
  name    = "transit-non-ha-gcp"
  region  = "us-east1"
  cidr    = "10.1.0.0/23"
  account = "GCP"
  ha_gw   = false
}
