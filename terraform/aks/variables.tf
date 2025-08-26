variable "cluster_name" { default = "ephemeral-cluster" }
variable "azure_location" { default = "eastus" }
variable "azure_node_vm_size" { default = "Standard_B2s" }
variable "azure_resource_group_name" { default = "ephemeral-env-factory" }
variable "azure_dns_prefix" { default = "ephemeral-k8s" }
variable "azure_kubernetes_version" { default = "1.32.5" }
