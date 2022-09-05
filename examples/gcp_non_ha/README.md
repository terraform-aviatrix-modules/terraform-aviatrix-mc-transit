### Usage Example GCP HA

In this example, the module deploys the transit VPC as well as a single of Aviatrix transit gateway in GCP.

```hcl
module "transit_non_ha_gcp" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.2.1"

  cloud   = "gcp"
  name    = "transit-non-ha-gcp"
  region  = "us-east1"
  cidr    = "10.1.0.0/23"
  account = "GCP"
  ha_gw   = false
}
```