resource "azurerm_resource_group" "compute_rg" {
  location = var.location
  name     = "compute-rg"
}

#VM components
resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.compute_rg.location
  resource_group_name = azurerm_resource_group.compute_rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.privatesubnetVM.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "vm"
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  location              = azurerm_resource_group.compute_rg.location
  resource_group_name   = azurerm_resource_group.compute_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = "Standard_F2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

#Website
# Storage Account für statische Website
resource "azurerm_storage_account" "web" {
  name                     = "websitestorage${random_string.rand.result}"
  resource_group_name      = azurerm_resource_group.compute_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
}

# Optional: Beispielindex.html hochladen
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = "<h1>Hello World from Terraform Static Website</h1>"
}

# Random Suffix für eindeutigen Storage Account
resource "random_string" "rand" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}


