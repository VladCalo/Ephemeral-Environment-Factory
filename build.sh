#!/bin/bash

# terraform
# ansible main playbook
# export KUBECONFIG=$(pwd)/admin.conf
# generate argoCD templates with go. call the go binary from the go dir: ./generator nginx-app nginx-chart default
# argoCD playbook
# port-forward argoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443


# get password
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo


SRC_DIR=$(pwd)
GO_DIR="$SRC_DIR/go"
ANSIBLE_DIR="$SRC_DIR/ansible"
TERRAFORM_DIR="$SRC_DIR/terraform"
ARGOCD_DIR="$SRC_DIR/argocd"
HELM_DIR="$SRC_DIR/helm"