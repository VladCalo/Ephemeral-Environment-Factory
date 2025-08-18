terraform {
  required_version = ">= 1.3.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Validate that at least one cluster type is enabled
locals {
  cluster_enabled = var.enable_local_cluster || var.enable_azure_cluster
}

# Validation check
resource "null_resource" "validation" {
  count = local.cluster_enabled ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: At least one cluster type must be enabled (enable_local_cluster or enable_azure_cluster)' && exit 1"
  }
}

module "local_cluster" {
  count  = var.enable_local_cluster ? 1 : 0
  source = "./modules/local-vm"

  cluster_name     = var.cluster_name
  master_count     = var.master_count
  worker_count     = var.worker_count
  master_cpus      = var.master_cpus
  master_mem       = var.master_mem
  master_disk_size = var.master_disk_size
  worker_cpus      = var.worker_cpus
  worker_mem       = var.worker_mem
  worker_disk_size = var.worker_disk_size
  ssh_pub_key_path = var.ssh_pub_key_path

  depends_on = [null_resource.validation]
}

module "azure_cluster" {
  count  = var.enable_azure_cluster ? 1 : 0
  source = "./modules/azure"

  cluster_name              = var.cluster_name
  azure_location            = var.azure_location
  azure_resource_group_name = var.azure_resource_group_name
  azure_dns_prefix          = var.azure_dns_prefix
  azure_node_vm_size        = var.azure_node_vm_size
  azure_kubernetes_version  = var.azure_kubernetes_version

  depends_on = [null_resource.validation]
}
