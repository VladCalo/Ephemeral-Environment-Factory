#!/bin/bash

# terraform
# ansible main playbook
# export KUBECONFIG=$(pwd)/admin.conf
# argoCD playbook
# port-forward argoCD: kubectl port-forward svc/argocd-server -n argocd 8080:443


# get password
# kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
