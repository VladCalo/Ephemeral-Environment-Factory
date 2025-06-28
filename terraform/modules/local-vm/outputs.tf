output "master_names" {
  value = [for i in range(var.master_count) : "${var.cluster_name}-master-${i + 1}"]
}

output "worker_names" {
  value = [for i in range(var.worker_count) : "${var.cluster_name}-worker-${i + 1}"]
}
