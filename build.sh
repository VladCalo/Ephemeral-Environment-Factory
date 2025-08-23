#!/bin/bash

set -x

check_multipass() {
    if ! command -v multipass &> /dev/null; then
        echo "Multipass not found. Please install multipass first."
        exit 1
    fi
    
    if ! multipass list &> /dev/null; then
        echo "Multipass not running. Starting multipass..."
        multipass start
        sleep 5
        echo "Multipass started successfully."
    fi
}

check_azure() {
    if ! command -v az &> /dev/null; then
        echo "Azure CLI not found. Please install azure-cli first."
        exit 1
    fi
    
    if ! az account show &> /dev/null; then
        echo "Not logged into Azure. Please run 'az login' first."
        exit 1
    fi
}

check_python_env() {
    if [ ! -d ".venv" ]; then
        echo "Python virtual environment not found. Creating .venv..."
        python3 -m venv .venv
    fi
    
    if [ ! -f ".venv/bin/activate" ]; then
        echo "Virtual environment activation script not found. Creating new venv..."
        rm -rf .venv
        python3 -m venv .venv
    fi
    
    echo "Activating virtual environment..."
    source .venv/bin/activate
    
    if ! pip show ansible &> /dev/null; then
        echo "Installing requirements..."
        pip install -r requirements.txt
    fi
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 <apply|destroy> <multipass|aks>"
    exit 1
fi

ACTION=$1
TYPE=$2

case $ACTION in
    apply)
        case $TYPE in
            multipass)
                check_multipass
                check_python_env
                cd terraform
                terraform init
                terraform plan -var="enable_local_cluster=true"
                terraform apply -var="enable_local_cluster=true" -auto-approve
                
                cd ../scripts
                python3 parse_multipass.py
                
                cd ../ansible
                ansible-playbook playbook.yaml -v
                echo "Multipass deployment completed successfully!"
                exit 0
                ;;
            aks)
                check_azure
                check_python_env
                cd terraform
                terraform init
                terraform plan -var="enable_azure_cluster=true"
                terraform apply -var="enable_azure_cluster=true" -auto-approve
                
                terraform output -raw azure_kube_config > ~/.kube/azure.conf
                echo "AKS deployment completed successfully!"
                exit 0
                ;;
            *)
                echo "Invalid type: $TYPE. Use multipass or aks"
                exit 1
                ;;
        esac
        ;;
    destroy)
        case $TYPE in
            multipass)
                cd terraform/modules/local-vm
                bash destroy.sh
                echo "Multipass cluster destroyed successfully!"
                exit 0
                ;;
            aks)
                cd terraform
                terraform destroy -var="enable_azure_cluster=true" -auto-approve
                echo "AKS cluster destroyed successfully!"
                exit 0
                ;;
            *)
                echo "Invalid type: $TYPE. Use multipass or aks"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Invalid action: $ACTION. Use apply or destroy"
        exit 1
        ;;
esac
