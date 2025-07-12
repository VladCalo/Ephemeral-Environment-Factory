variable "cluster_name" {
  default = "ephemeral-cluster"
}

variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 2
}

variable "master_cpus" {
  default = 2
}

variable "master_mem" {
  default = "2G"
}

variable "worker_cpus" {
  default = 1
}

variable "worker_mem" {
  default = "1G"
}

variable "worker_disk_size" {
  default = "10G"
}

variable "master_disk_size" {
  default = "10G"
}

variable "ssh_pub_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

#! Azure-specific variables
variable "azure_location" {
  default = "eastus"
}

variable "azure_node_vm_size" {
  default = "Standard_B2s"
}

variable "azure_resource_group_name" {
  default = "ephemeral-env-factory"
}

variable "azure_dns_prefix" {
  default = "ephemeral-k8s"
}

variable "azure_kubernetes_version" {
  default = "1.32.5"
}