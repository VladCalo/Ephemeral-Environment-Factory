#! Azure module outputs
output "azure_kube_config" {
  value     = var.enable_azure_cluster ? module.azure_cluster[0].kube_config : null
  sensitive = true
}

output "azure_resource_group_name" {
  value = var.enable_azure_cluster ? module.azure_cluster[0].resource_group_name : null
}

#! Local module outputs
output "local_master_names" {
  value = var.enable_local_cluster ? module.local_cluster[0].master_names : null
}

output "local_worker_names" {
  value = var.enable_local_cluster ? module.local_cluster[0].worker_names : null
}