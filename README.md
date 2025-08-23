# Ephemeral Environment Factory

## Overview

The Ephemeral Environment Factory creates temporary Kubernetes clusters for development, testing, and CI/CD purposes. It provides infrastructure automation for spinning up ephemeral Kubernetes environments using either local Multipass VMs or Azure Kubernetes Service (AKS).

**Note**: This repository focuses solely on infrastructure provisioning and cluster setup. For application deployment and GitOps workflows, see [GitOps-Platform-Factory](https://github.com/vladcalo/GitOps-Platform-Factory) repository.

## Architecture

The project consists of two main layers:

### Infrastructure Layer

- **Terraform Modules**: Infrastructure as Code for both local and cloud environments
- **Multipass Integration**: Local VM provisioning for development clusters
- **Azure AKS**: Cloud-based Kubernetes clusters for production-like testing

### Configuration Management

- **Ansible Playbooks**: Automated cluster setup and configuration
- **Cloud-init Templates**: VM initialization and bootstrap configuration

## Current Cluster Configuration

**Default Local Cluster**: 1 Master Node + 2 Worker Nodes

- **Master**: 2 CPU cores, 2GB RAM, 10GB disk
- **Workers**: 1 CPU core, 1GB RAM, 10GB disk each
- **Architecture**: ARM64/x86_64 agnostic (works on Apple Silicon, Intel, AMD)

**Default Azure Cluster**: AKS with Standard_B2s nodes, Kubernetes 1.32.5

## Project Structure

```
Ephemeral-Environment-Factory/
├── ansible/                    # Ansible configuration and playbooks
│   ├── inventory/             # Host inventory definitions
│   └── roles/                # Ansible roles for cluster setup
│       ├── common/           # Shared configuration tasks
│       ├── master/           # Kubernetes master node setup
│       └── worker/           # Kubernetes worker node setup
├── terraform/               # Infrastructure as Code
│   ├── modules/             # Terraform modules
│   │   ├── azure/          # Azure AKS module
│   │   └── local-vm/       # Multipass VM module
│   ├── cloud-init/          # VM initialization templates
│   └── main.tf             # Main Terraform configuration
├── requirements.txt         # Python dependencies for Ansible
└── build.sh                # Build automation script
```

## Key Features

### Multi-Environment Support

- **Local Development**: Multipass-based VMs for local Kubernetes clusters
- **Cloud Deployment**: Azure AKS integration for production-like environments
- **Flexible Configuration**: Customizable cluster sizes and specifications

### Infrastructure Automation

- **Terraform**: Complete infrastructure provisioning
- **Ansible**: Automated cluster configuration and setup
- **Cloud-init**: VM initialization and bootstrap

## Prerequisites

### System Requirements

- **Terraform** >= 1.3.0
- **Ansible** >= 2.9
- **kubectl** >= 1.28
- **Multipass** (for local clusters)
- **Azure CLI** (for Azure clusters)

## Quick Start

### Automated Deployment

Use the build script to automate the entire deployment process:

```bash
# Deploy local cluster (Multipass)
./build.sh apply multipass

# Deploy Azure cluster (AKS)
./build.sh apply aks

# Destroy clusters
./build.sh destroy multipass
./build.sh destroy aks
```

### What the Build Script Does

**For Multipass:**

- Checks if multipass is installed and running
- Starts multipass automatically if needed
- Runs terraform init/plan/apply
- Updates ansible inventory with current IPs
- Runs ansible playbook for cluster setup

**For AKS:**

- Checks if Azure CLI is installed and authenticated
- Runs terraform init/plan/apply
- Exports kubeconfig to ~/.kube/azure.conf

## Ansible Configuration

The Ansible playbooks handle:

- Docker and containerd installation
- Kubernetes components setup
- Cluster initialization (master/worker)
- Network plugin configuration (Flannel)

## Development Workflow

1. **Automated Deployment**: Use `./build.sh apply multipass` or `./build.sh apply aks`
2. **Cluster Ready**: Infrastructure and configuration handled automatically
3. **Connect to Cluster**: Use kubectl to interact with the cluster
4. **Deploy Applications**: Use the GitOps-Platform-Factory for application deployment

## Integration with GitOps Platform

After provisioning a cluster with this repository, you can:

1. **Export Kubeconfig**: Get the cluster configuration
2. **Configure GitOps**: Use the GitOps-Platform-Factory to deploy applications
3. **Manage Applications**: Handle application lifecycle through ArgoCD

## Kubectl Configuration

### Local Cluster (Multipass)

After successful deployment, the kubeconfig is stored at:

```bash
~/.kube/admin.conf
```

Use it with:

```bash
export KUBECONFIG=~/.kube/admin.conf
kubectl get nodes
```

### Azure Cluster (AKS)

After successful deployment, the kubeconfig is stored at:

```bash
~/.kube/azure.conf
```

Use it with:

```bash
export KUBECONFIG=~/.kube/azure.conf
kubectl get nodes
```

## Current Limitations

**Project is not yet finished** - The following areas need completion:

- ✅ **Error Handling**: Improved error handling and validation
- ✅ **Automate Deploy**: Build script automates cloud/local deployment + multipass hosts.ini IPs
- ❌ **Build Optimizations**: current 8 mins, target 1 mins with prebuilt images
- ❌ **TTL Cleanup**: TTL
- ❌ **Security**: Enhanced security configurations and RBAC
- ❌ **Monitoring**: Integration with monitoring and logging solutions
- ❌ **CI/CD**: Automated testing and deployment pipelines
- ❌ **Scaling**: Horizontal scaling and load balancing

## Related Repositories

- **[GitOps-Platform-Factory](https://github.com/vladcalo/GitOps-Platform-Factory)**: Application deployment, Helm charts, and ArgoCD configuration
