resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_private_endpoint" "postgres" {
  name = "postgres-private-endpoint"

  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  subnet_id = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name = "postgres-private-connection"

    private_connection_resource_id = azurerm_postgresql_flexible_server.postgres.id

    is_manual_connection = false

    subresource_names = [
      "postgresqlServer"
    ]
  }

  private_dns_zone_group {
    name = "postgres-dns-zone-group"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.postgres.id
    ]
  }
}