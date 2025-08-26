# Ephemeral Environment Factory

## Overview

The Ephemeral Environment Factory is a **plug-and-play solution** that automatically spins up Kubernetes clusters in minutes. Deploy clusters locally using Multipass VMs or in the cloud with Azure AKS - all with a single command.

**Purpose**: Infrastructure automation for development, testing and CI/CD environments. This repository handles cluster provisioning and setup. For application deployment via GitOps see [GitOps-Platform-Factory](https://github.com/vladcalo/GitOps-Platform-Factory).

## Quick Summary

**What it does**: Automatically creates Kubernetes clusters (local or cloud)  
**How to use**: `./manage.sh apply multipass` or `./manage.sh apply aks`  
**Time to deploy**: ~5 minutes for a fully functional cluster
**!!!SSH Keys:**: generate ssh keys in ~/.ssh/ (multipass makes use of it)
**Resources**: Production-ready K8s cluster with networking, storage and monitoring

## Architecture

The project consists of two main layers:

### Infrastructure Layer

- **Terraform Modules**: IaC for both local and cloud environments
- **Multipass Integration**: Local VM provisioning for dev clusters
- **Azure AKS**: Cloud-based Kubernetes clusters for production-like testing

### Config Management

- **Ansible Playbooks**: Automated cluster setup and configuration
- **Cloud-init Templates**: VM initialization

## Current Cluster Configuration

**Default Local Cluster**: 1 Master Node + 2 Worker Nodes

- **Master**: 2 CPU cores, 2GB RAM, 10GB disk
- **Workers**: 1 CPU core, 1GB RAM, 10GB disk each
- **Architecture**: ARM64/x86_64 agnostic (works on Apple Silicon, Intel, AMD)

**Default Azure Cluster**: AKS with Standard_B2s nodes, Kubernetes 1.32.5

## Key Features

### Plug-and-Play Deployment

- **Single Command**: `./manage.sh apply multipass` or `./manage.sh apply aks`
- **Zero Configuration**: Pre-configured cluster settings ready to use
- **Automatic Setup**: Infrastructure, networking and Kubernetes components deployed automatically

### Multi-Environment Support

- **Local Development**: Multipass-based VMs for local Kubernetes clusters
- **Cloud Deployment**: Azure AKS integration for production-like environments
- **Architecture Agnostic**: Works on ARM64 (Apple Silicon) and x86_64 systems

### Infrastructure Automation

- **Terraform**: Complete infrastructure provisioning
- **Ansible**: Automated cluster configuration and setup
  - Docker and containerd installation
  - Kubernetes components setup
  - Cluster initialization (master/worker)
  - Network plugin configuration (Flannel)
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

Use the manage script to automate the entire deployment process:

```bash
# Deploy local cluster (Multipass)
./manage.sh apply multipass

# Deploy Azure cluster (AKS)
./manage.sh apply aks

# Destroy clusters
./manage.sh destroy multipass
./manage.sh destroy aks
```

## Project Structure

```
Ephemeral-Environment-Factory/
├── ansible/                    # Ansible configuration and playbooks
│   ├── inventory/             # Host inventory
│   └── roles/                # Ansible roles for cluster setup
│       ├── common/           # Shared configuration tasks
│       ├── master/           # Kubernetes master node setup
│       └── worker/           # Kubernetes worker node setup
├── terraform/               # IaC
│   ├── multipass/           # Multipass configuration
│   │   ├── main.tf         # Multipass main config
│   │   ├── variables.tf    # Multipass variables
│   │   └── outputs.tf      # Multipass outputs
│   ├── aks/                # AKS configuration
│   │   ├── main.tf         # AKS main config
│   │   ├── variables.tf    # AKS variables
│   │   └── outputs.tf      # AKS outputs
│   ├── modules/             # Terraform modules
│   │   ├── azure/          # Azure AKS module
│   │   └── local-vm/       # Multipass VM module
│   └── cloud-init/          # VM initialization templates
├── requirements.txt         # Python dependencies for Ansible
└── manage.sh                # Manage automation script
```

## Development Workflow

1. **Automated Deployment**: Use `./manage.sh apply multipass` or `./manage.sh apply aks`
2. **Cluster Ready**: Infrastructure and configuration handled automatically
3. **Connect to Cluster**: Use kubectl to interact with the cluster
4. **Deploy Applications**: Use the GitOps-Platform-Factory for application deployment

## Integration with GitOps Platform

After provisioning a cluster with this repository, you can:

1. **Export Kubeconfig**: Get the cluster configuration
2. **Configure GitOps**: Use the GitOps-Platform-Factory to deploy applications
3. **Manage Applications**: Handle application lifecycle through ArgoCD

## Kubectl Configuration

After successful deployment, the kubeconfig is stored at:

```bash
~/.kube/admin.conf # Multipass
~/.kube/azure.conf # Azure
```

## Current Limitations

**Project is not yet finished** - The following areas need completion:

- ✅ **Error Handling**: Improved error handling and validation
- ✅ **Automate Deploy**: Build script automates cloud/local deployment + multipass hosts.ini IPs
- ❌ **Monitoring**: Cluster health monitoring
- ❌ **TTL Cleanup**: TTL
- ❌ **CI/CD**: Automated testing and deployment pipelines
- ❌ **Scaling**: Horizontal scaling and load balancing

## Related Repositories

- **[GitOps-Platform-Factory](https://github.com/vladcalo/GitOps-Platform-Factory)**: Application deployment, Helm charts, and ArgoCD configuration
