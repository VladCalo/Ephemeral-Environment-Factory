terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
}

module "azure_cluster" {
  source = "../modules/azure"
  cluster_name = var.cluster_name
  azure_location = var.azure_location
  azure_resource_group_name = var.azure_resource_group_name
  azure_dns_prefix = var.azure_dns_prefix
  azure_node_vm_size = var.azure_node_vm_size
  azure_kubernetes_version = var.azure_kubernetes_version
}
