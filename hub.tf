resource "azurerm_resource_group" "hub_rg" {
    name = "hub-rg"
    location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "example-network"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = ["10.0.0.0/16"]
  }


#Firewall components
resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewallip" {
  name                = "firewallip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static" # oder nicht?
  sku                 = "Standard" # oder basic?
}

resource "azurerm_firewall" "hub_firewall" {
  name                = "hub_firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallip.id
  }
}

#Bastion Host Components
resource "azurerm_subnet" "bastionsubnet" {
  name                = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_prefixes       = ["10.0.2.0/27"]
}

resource "azurerm_public_ip" "bastionip" {
  name                = "bastionip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionhost" {
  name                = "bastionhost"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionip.id
  }
}
