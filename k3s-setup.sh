#!/bin/bash

# This script installs K3s - a lightweight Kubernetes distribution
# K3s is easier to install than Minikube and works better on smaller instances

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Wait for K3s to start
sleep 10

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo chmod 600 $HOME/.kube/config

# Set KUBECONFIG environment variable
echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
export KUBECONFIG=$HOME/.kube/config

# Verify the cluster is running
kubectl get nodes

echo "K3s Kubernetes setup complete!"