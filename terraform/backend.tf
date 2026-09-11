terraform {
  backend "azurerm" {
    resource_group_name  = "aks-terraform-state-rg"
    storage_account_name = "aksfulltfstate2026"
    container_name       = "tfstate"
    key                  = "aks-fullstack.tfstate"

    use_oidc         = true
    use_azuread_auth = true
  }
}