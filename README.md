# Ephemeral Environment Factory

**⚠️ Project Status: Work in Progress**  
This project is currently under active development and is not yet complete. Some features may be incomplete or require additional configuration.

## Overview

The Ephemeral Environment Factory creates temporary Kubernetes clusters for development, testing, and CI/CD purposes. It provides infrastructure automation for spinning up ephemeral Kubernetes environments using either local Multipass VMs or Azure Kubernetes Service (AKS).

## Architecture

The project consists of three main layers:

### Infrastructure Layer

- **Terraform Modules**: Infrastructure as Code for both local and cloud environments
- **Multipass Integration**: Local VM provisioning for development clusters
- **Azure AKS**: Cloud-based Kubernetes clusters for production-like testing

### Application Layer

- **Go Template Generator**: Automated ArgoCD application manifest generation
- **Helm Charts**: Application packaging and deployment templates
- **ArgoCD**: GitOps-based application deployment and management

### Configuration Management

- **Ansible Playbooks**: Automated cluster setup and configuration
- **Cloud-init Templates**: VM initialization and bootstrap configuration

## Project Structure

```
Ephemeral-Environment-Factory/
├── ansible/                    # Ansible configuration and playbooks
│   ├── inventory/             # Host inventory definitions
│   ├── playbooks/            # ArgoCD deployment playbooks
│   └── roles/                # Ansible roles for cluster setup
│       ├── common/           # Shared configuration tasks
│       ├── master/           # Kubernetes master node setup
│       └── worker/           # Kubernetes worker node setup
├── argocd/                   # Generated ArgoCD application manifests
├── go/                       # Go template generator
│   ├── templates/            # Application manifest templates
│   └── main.go              # Template generation logic
├── helm/                     # Helm charts for applications
│   ├── nginx-chart/         # Sample nginx application
│   └── whoami-chart/        # Sample whoami application
├── terraform/               # Infrastructure as Code
│   ├── modules/             # Terraform modules
│   │   ├── azure/          # Azure AKS module
│   │   └── local-vm/       # Multipass VM module
│   ├── cloud-init/          # VM initialization templates
│   └── main.tf             # Main Terraform configuration
└── build.sh                # Build automation script
```

## Key Features

### Multi-Environment Support

- **Local Development**: Multipass-based VMs for local Kubernetes clusters
- **Cloud Deployment**: Azure AKS integration for production-like environments
- **Flexible Configuration**: Customizable cluster sizes and specifications

### GitOps Workflow

- **Automated Deployment**: ArgoCD manages application lifecycle
- **Template Generation**: Go-based manifest generation from Helm charts
- **Version Control**: All configurations tracked in Git

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
- **Go** >= 1.19 (for template generation)

### Dependencies

```bash
# Install Python dependencies
pip install -r requirements.txt

# Install Go dependencies
cd go && go mod tidy
```

## Quick Start

### 1. Generate Application Manifests

```bash
cd go
./generator nginx-app nginx-chart default
./generator whoami-app whoami-chart default
```

### 2. Deploy Local Cluster (Multipass)

```bash
cd terraform/
terraform init
terraform plan -var="enable_local_cluster=true"
terraform apply -var="enable_local_cluster=true"

# Configure cluster with Ansible
cd ../ansible/
ansible-playbook playbook.yaml -v

# Deploy ArgoCD
cd playbooks/
ansible-playbook argo.yaml -e kubeconfig_path=/Users/vladcalomfirescu/.kube/admin.conf

# Access ArgoCD UI
KUBECONFIG=~/.kube/admin.conf kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
KUBECONFIG=~/.kube/admin.conf kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
```

### 3. Deploy Azure Cluster (AKS)

```bash
cd terraform/
terraform init
terraform plan -var="enable_azure_cluster=true"
terraform apply -var="enable_azure_cluster=true"

# Get kubeconfig
terraform output -raw azure_kube_config > ~/.kube/azure.conf

# Deploy ArgoCD
cd ../ansible/playbooks/
ansible-playbook argo.yaml -e kubeconfig_path=/Users/vladcalomfirescu/.kube/azure.conf

# Access ArgoCD UI
KUBECONFIG=~/.kube/azure.conf kubectl port-forward svc/argocd-server -n argocd 8080:443

# Cleanup
cd ../../terraform
terraform destroy -var="enable_azure_cluster=true"
```

## Ansible Configuration

The Ansible playbooks handle:

- Docker and containerd installation
- Kubernetes components setup
- Cluster initialization (master/worker)
- Network plugin configuration (Flannel)
- ArgoCD deployment

## Application Deployment

### Helm Charts

The project includes sample Helm charts:

- **nginx-chart**: Basic nginx web server
- **whoami-chart**: HTTP server returning request information

### ArgoCD Applications

Applications are automatically generated from Helm charts using the Go template generator:

- Creates ArgoCD Application manifests
- Configures GitOps workflow
- Enables automated deployment and sync

## Development Workflow

1. **Create Helm Chart**: Add new application charts to `helm/`
2. **Generate Manifests**: Use Go generator to create ArgoCD apps
3. **Deploy Infrastructure**: Use Terraform to provision cluster
4. **Configure Cluster**: Run Ansible playbooks for setup
5. **Deploy Applications**: ArgoCD automatically deploys from Git

## Current Limitations

**Project is not yet finished** - The following areas need completion:

- [ ] **Error Handling**: Improved error handling and validation
- [ ] **Security**: Enhanced security configurations and RBAC
- [ ] **Monitoring**: Integration with monitoring and logging solutions
- [ ] **Testing**: Comprehensive test suite and validation
- [ ] **Documentation**: API documentation and user guides
- [ ] **CI/CD**: Automated testing and deployment pipelines
- [ ] **Multi-cloud**: Support for additional cloud providers
- [ ] **Scaling**: Horizontal scaling and load balancing
- [ ] **Backup**: Data persistence and backup strategies

## Contributing

This project is actively under development. Contributions are welcome in the following areas:

- Infrastructure improvements
- Security enhancements
- Documentation updates
- Testing and validation
- New feature development

## License

[Add your license information here]

## Support

For issues and questions, please create an issue in the project repository.
