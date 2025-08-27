#!/bin/bash

check_multipass() {
    command -v multipass >/dev/null 2>&1 || { echo "Multipass not found. Install multipass first."; exit 1; }
    multipass list >/dev/null 2>&1 || { echo "Starting multipass..."; multipass start; sleep 5; }
}

check_azure() {
    command -v az >/dev/null 2>&1 || { echo "Azure CLI not found. Install azure-cli first."; exit 1; }
    az account show >/dev/null 2>&1 || { echo "Not logged into Azure. Run 'az login' first."; exit 1; }
    az group show --name ephemeral-env-factory >/dev/null 2>&1 || az group create --name ephemeral-env-factory --location eastus
}

check_python_env() {
    [ ! -d ".venv" ] && python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
}

[ $# -ne 2 ] && { echo "Usage: $0 <apply|destroy> <multipass|aks>"; exit 1; }

ACTION=$1
TYPE=$2

case $ACTION in
    apply)
        case $TYPE in
            multipass)
                check_multipass
                check_python_env
                cd terraform/multipass
                terraform init && terraform apply -auto-approve
                cd ../../scripts
                python3 parse_multipass.py
                cd ../ansible
                ansible-playbook playbook.yaml -v
                echo "Multipass deployment completed!"
                deactivate
                exit 0
                ;;
            aks)
                check_azure
                check_python_env
                cd terraform/aks
                terraform init && terraform apply -auto-approve
                terraform output -raw azure_kube_config > ~/.kube/azure.conf
                echo "AKS deployment completed!"
                deactivate
                exit 0
                ;;
            *) echo "Invalid type: $TYPE. Use multipass or aks"; exit 1 ;;
        esac
        ;;
    destroy)
        case $TYPE in
            multipass)
                rm -f terraform/multipass/terraform.tfstate*
                cd terraform/modules/local-vm
                bash destroy.sh
                echo "Multipass cluster destroyed!"
                exit 0
                ;;
            aks)
                cd terraform/aks
                terraform init && terraform destroy -auto-approve
                echo "AKS cluster destroyed!"
                exit 0
                ;;
            *) echo "Invalid type: $TYPE. Use multipass or aks"; exit 1 ;;
        esac
        ;;
    *) echo "Invalid action: $ACTION. Use apply or destroy"; exit 1 ;;
esac
