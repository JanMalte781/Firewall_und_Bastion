resource "azurerm_resource_group" "spoke_rg" {
  name     = "spoke_rg"
  location = var.location
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "spoke-vnet"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "privatesubnetVM" {
  name                 = "private-subnet-VM"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "privatesubnetWebServer" {
  name                 = "private-subnet-WebServer"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}
