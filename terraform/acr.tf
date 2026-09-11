resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name_prefix}${random_string.acr_suffix.result}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  sku           = "Basic"
  admin_enabled = false

  tags = {
    Project = "AKS Fullstack"
  }
}

resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = "b9ebd6da-eabe-4335-813e-56518801c44a4"
}