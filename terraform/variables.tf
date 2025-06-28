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

