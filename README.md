# Ephemeral-Environment-Factory

### On master:
sudo cp /etc/kubernetes/admin.conf /home/ubuntu/admin.conf
sudo chown ubuntu:ubuntu /home/ubuntu/admin.conf

multipass copy-files ephemeral-cluster-master:/home/ubuntu/admin.conf ./admin.conf
export KUBECONFIG=$PWD/admin.conf

# ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
https://localhost:8080
admin/1DKJwL8voH07qgzK

# TODO: 
provison steps refactor:
terraform
ansible playbook on hosts
ansible argoCD local


read about admin.conf from multiple clusters. 
fix admin.conf in argo.yaml because when executing then i need to repoint in root
dynamic ips
multiple argo cd apps and how to make them dynamic. if someone want to use project and comes with their own helm chart
multiple complex helm charts
