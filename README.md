# Ephemeral-Environment-Factory

### First, go templates
call the go binary from the go dir: ./generator nginx-app nginx-chart default

### Test cluster
1 worker / 2 nodes

### Multipass
```bash
cd terraform/
terraform init
terraform plan -var="enable_local_cluster=true"
terraform apply -var="enable_local_cluster=true"
# manually update ansible hosts : TBD
cd ..
cd ansible/
ansible-playbook playbook.yaml -v
cd playbooks/
ansible-playbook argo.yaml -e kubeconfig_path=/Users/vladcalomfirescu/.kube/admin.conf
KUBECONFIG=~/.kube/admin.conf kubectl port-forward svc/argocd-server -n argocd 8080:443
KUBECONFIG=~/.kube/admin.conf kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
```

### Azure
```bash
cd terraform/
terraform init
terraform plan -var="enable_azure_cluster=true"
terraform apply -var="enable_azure_cluster=true"
terraform output -raw azure_kube_config > ~/.kube/azure.conf
# ansible only used to configure multipass kube cluster
# for azure use AKS with default config
cd ../ansible/playbooks/
ansible-playbook argo.yaml -e kubeconfig_path=/Users/vladcalomfirescu/.kube/azure.conf
KUBECONFIG=~/.kube/azure.conf kubectl port-forward svc/argocd-server -n argocd 8080:443
KUBECONFIG=~/.kube/azure.conf kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
cd ../../terraform
terraform destroy -var="enable_azure_cluster=true"
```