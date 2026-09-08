resource "random_string" "postgres_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name = "${var.postgres_name_prefix}${random_string.postgres_suffix.result}"

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  version = "16"

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7

  public_network_access_enabled = true

  tags = {
    Project = "AKS Fullstack"
  }
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "productdb"
  server_id = azurerm_postgresql_flexible_server.postgres.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}
