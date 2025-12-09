# Ephemeral Environment Factory

Spins up Kubernetes clusters locally (Multipass VMs) or in Azure (AKS) with a single command.

For application deployment via GitOps see [GitOps-Platform-Factory](https://github.com/vladcalo/GitOps-Platform-Factory).

## Usage

```bash
./manage.sh apply multipass    # local cluster
./manage.sh apply aks          # azure cluster
./manage.sh destroy multipass
./manage.sh destroy aks
```

**Note**: Generate SSH keys in `~/.ssh/` before using multipass.

## Cluster Defaults

**Local (Multipass)**: 1 master (2 CPU, 2GB RAM) + 2 workers (1 CPU, 1GB RAM). ARM64/x86_64 agnostic.

**Azure**: AKS with Standard_B2s nodes, Kubernetes 1.32.5.

## Stack

- **Terraform**: VM/cloud provisioning
- **Ansible**: Kubernetes setup (docker, containerd, flannel CNI)
- **Cloud-init**: VM bootstrap

## Monitoring

Deployed on master node:

- Prometheus: `<master-ip>:9090`
- Node metrics: `<master-ip>:9100`
- Grafana: `<master-ip>:3000` (admin/admin)

Custom dashboards: `ansible/roles/master/grafana/dashboards/`

## Kubeconfig

```bash
~/.kube/admin.conf  # multipass
~/.kube/azure.conf  # azure
```

## Prerequisites

- Terraform >= 1.3.0
- Ansible >= 2.9
- kubectl >= 1.28
- Multipass (local) / Azure CLI (cloud)
