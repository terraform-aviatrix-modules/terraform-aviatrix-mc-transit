### Usage Example Azure HA Transit Gateway deployment when Public IP are passed and would be preserved when deleting/redeploying GWs. 

In this example, the module deploys the transit VNET as well as a HA pair of Aviatrix transit gateways.
It is mandatory to deploy them in existing Resource Group where Public IPs were created. 
EIP is passed then as a set of attributes along with this resrouce_group name.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "PIP-RG"
  location = "West Europe"
}

resource "azurerm_public_ip" "pip1" {
  name                = "PIP-TrGW"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "pip2" {
  name                = "PIP-TrGW-ha"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "mc-transit" {
  source                           = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version                          = "2.3.3"
  resource_group                   = azurerm_resource_group.example.name
  cloud                            = "Azure"
  region                           = "West Europe"
  cidr                             = "10.17.0.0/23"
  account                          = "azure-account-onboarded-on-ctrl"
 
  allocate_new_eip                 = false
  eip                              = azurerm_public_ip.pip1.ip_address
  azure_eip_name_resource_group    = "${azurerm_public_ip.pip1.name}:${azurerm_resource_group.example.name}"
  ha_eip                           = azurerm_public_ip.pip2.ip_address
  ha_azure_eip_name_resource_group = "${azurerm_public_ip.pip2.name}:${azurerm_resource_group.example.name}"

  depends_on = [
    azurerm_public_ip.pip1,
    azurerm_public_ip.pip2
  ]
}
```
