output "azure_kube_config" { 
  value = module.azure_cluster.kube_config
  sensitive = true 
}
output "azure_resource_group_name" { value = module.azure_cluster.resource_group_name }
