#!/bin/bash

# first, generate argoCD templates with go. call the go binary from the go dir: ./generator nginx-app nginx-chart default

# terraform (call from terraform dir)
# ansible main playbook (call from ansible dir)
# export KUBECONFIG=$(pwd)/admin.conf
# argoCD playbook (from its dir)
# port-forward argoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443


# get password
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo


SRC_DIR=$(pwd)
GO_DIR="$SRC_DIR/go"
ANSIBLE_DIR="$SRC_DIR/ansible"
TERRAFORM_DIR="$SRC_DIR/terraform"
ARGOCD_DIR="$SRC_DIR/argocd"
HELM_DIR="$SRC_DIR/helm"