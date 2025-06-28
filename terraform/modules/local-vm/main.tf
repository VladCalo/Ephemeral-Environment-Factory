resource "null_resource" "master" {
  provisioner "local-exec" {
    command = "multipass launch --name ${var.cluster_name}-master --cpus ${var.master_cpus} --memory ${var.master_mem} --disk ${var.master_disk_size}"
  }
}

resource "null_resource" "workers" {
  count = var.worker_count

  provisioner "local-exec" {
    command = "multipass launch --name ${var.cluster_name}-worker-${count.index + 1} --cpus ${var.worker_cpus} --memory ${var.worker_mem} --disk ${var.worker_disk_size}"
  }
}