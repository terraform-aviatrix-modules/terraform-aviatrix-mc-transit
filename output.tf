output "vpc" {
  description = "The created VPC as an object with all of it's attributes. This was created using the aviatrix_vpc resource."
  value       = aviatrix_vpc.default
}

output "transit_gateway" {
  description = "The created Aviatrix Transit Gateway as an object with all of it's attributes."
  value       = aviatrix_transit_gateway.default
}

#Firenet details is used when this module is combined with the mc-firenet module to propagate details between modules.
output "mc_firenet_details" {
  value = {
    name                   = local.name,
    az1                    = local.az1,
    az2                    = local.az2,
    single_az_mode         = local.single_az_mode,
    single_az_ha           = var.single_az_ha,
    ha_gw                  = var.ha_gw,
    cloud                  = local.cloud,
    availability_domain    = local.availability_domain,
    fault_domain           = local.fault_domain,
    ha_availability_domain = local.ha_availability_domain,
    ha_fault_domain        = local.ha_fault_domain,
    lan_vpc                = local.cloud == "gcp" && var.enable_transit_firenet ? aviatrix_vpc.lan_vpc[0] : null,
    region                 = var.region,
    ha_region              = var.ha_region,
    zone                   = local.zone,
    ha_zone                = local.ha_zone,
  }
}
