terraform {
  required_version = ">= 1.3.0"
  required_providers {
    null = { source = "hashicorp/null", version = "~> 3.0" }
  }
}

module "local_cluster" {
  source = "../modules/local-vm"
  cluster_name = var.cluster_name
  master_count = var.master_count
  worker_count = var.worker_count
  master_cpus = var.master_cpus
  master_mem = var.master_mem
  master_disk_size = var.master_disk_size
  worker_cpus = var.worker_cpus
  worker_mem = var.worker_mem
  worker_disk_size = var.worker_disk_size
  ssh_pub_key_path = var.ssh_pub_key_path
}
