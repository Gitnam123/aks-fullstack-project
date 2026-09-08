resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  dns_prefix = "aksfullstack"

  kubernetes_version = "1.36.3"

  default_node_pool {
    name = "system"

    vm_size = "Standard_D2s_v5"

    node_count = 1

    vnet_subnet_id = azurerm_subnet.aks.id

    type = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  role_based_access_control_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"

    network_policy = "azure"

    load_balancer_sku = "standard"

    service_cidr = "10.10.0.0/16"

    dns_service_ip = "10.10.0.10"

    pod_cidr = "10.244.0.0/16"
  }

  tags = {
    Project     = "AKS Fullstack"
    Environment = "Demo"
  }

  depends_on = [
    azurerm_subnet.aks
  ]
}
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  role_definition_name = "AcrPull"

  scope = azurerm_container_registry.acr.id
}
