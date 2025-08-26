resource "azurerm_resource_group" "k8s_rg" {
  name     = var.azure_resource_group_name
  location = var.azure_location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  dns_prefix          = var.azure_dns_prefix


  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = var.azure_node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = var.azure_kubernetes_version

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    Environment = "Ephemeral"
    ManagedBy   = "Terraform"
  }
}
