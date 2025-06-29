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
