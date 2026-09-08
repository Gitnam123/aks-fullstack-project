terraform {
  backend "azurerm" {
    resource_group_name  = "aks-fullstack-rg"
    storage_account_name = "aksfulltfstate2026"
    container_name       = "tfstate"
    key                  = "bootstrap.tfstate"
    use_azuread_auth     = true
  }
}