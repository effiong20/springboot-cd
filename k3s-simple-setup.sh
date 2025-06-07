#!/bin/bash

# Install K3s - a lightweight Kubernetes distribution
# This is much simpler than fixing Minikube issues

# Install K3s without traefik (to avoid port conflicts)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -

# Wait for K3s to start
sleep 10

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> $HOME/.bashrc

# Verify the cluster is running
kubectl get nodes

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Expose ArgoCD on NodePort 31145
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"name": "http", "port": 80, "nodePort": 31145}]}}'

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Get ArgoCD password
ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "====================================================="
echo "K3s and ArgoCD setup complete!"
echo "ArgoCD URL: http://$SERVER_IP:31145"
echo "Username: admin"
echo "Password: $ARGO_PASSWORD"
echo "====================================================="