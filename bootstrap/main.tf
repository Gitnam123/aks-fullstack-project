data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "terraform_state" {
  name = "aks-fullstack-rg"
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "aksfulltfstate2026"
  resource_group_name      = data.azurerm_resource_group.terraform_state.name
  location                 = data.azurerm_resource_group.terraform_state.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  min_tls_version                 = "TLS1_2"

  tags = {
    Project   = "AKS Fullstack"
    ManagedBy = "Terraform"
    Purpose   = "Terraform State"
  }
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "terraform_state_blob" {
  scope                = azurerm_storage_account.terraform_state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}