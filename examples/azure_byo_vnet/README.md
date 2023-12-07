### Usage Example Azure BYO VNET

In this example, the mc-transit module deploys just a HA pair of Aviatrix transit gateways in a VNET created externally.

```hcl
variable "region" {
  default = "West Europe"
}

variable "name" {
  default = "transit"
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.region
}

resource "azurerm_route_table" "this" {
  for_each            = toset(["private1", "private2", "public1", "public2"])
  name                = format("%s-%s", var.name, each.value)
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name

  #Only add blackhole routes for Internal route tables
  dynamic "route" {
    for_each = can(regex("private", each.value)) ? ["dummy"] : [] #Trick to make block conditional. Count not available on dynamic blocks.
    content {
      name           = "Blackhole"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "None"
    }
  }

  lifecycle {
    ignore_changes = [route, ] #Since the Aviatrix controller will maintain the routes, we want to ignore any changes to them in Terraform.
  }
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  vnet_name           = var.name
  vnet_location       = var.region
  use_for_each        = true
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.1.0.0/16"]
  subnet_prefixes = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.101.0/24",
    "10.1.102.0/24",
  ]
  subnet_names = [
    "Private1",
    "Private2",
    "Public1",
    "Public2",
  ]

  route_tables_ids = {
    Private1 = azurerm_route_table.this["private1"].id
    Private2 = azurerm_route_table.this["private2"].id
    Public1  = azurerm_route_table.this["public1"].id
    Public2  = azurerm_route_table.this["public2"].id
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}


module "azure_transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.5.2"

  cloud   = "azure"
  region  = var.region
  account = "Azure"

  use_existing_vpc = true
  vpc_id           = format("%s:%s:%s", module.vnet.vnet_name, azurerm_resource_group.this.name, module.vnet.vnet_guid)
  gw_subnet        = "10.1.101.0/24" #Public subnet
  hagw_subnet      = "10.1.102.0/24" #Public subnet
}
```