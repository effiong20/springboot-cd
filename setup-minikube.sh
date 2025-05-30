#!/bin/bash

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
fi

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Install conntrack (required for Minikube with --driver=none)
sudo apt install -y conntrack

# Stop any running minikube instances
sudo minikube stop || true
sudo minikube delete || true

# Start Minikube with none driver
sudo -E minikube start --driver=none

# Fix permissions for kubeconfig
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown -R $(id -u):$(id -g) $HOME/.kube/

# Set KUBECONFIG environment variable
echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
export KUBECONFIG=$HOME/.kube/config

# Verify cluster is running
kubectl cluster-info

echo "Minikube setup complete!"
echo "Run 'kubectl get nodes' to verify your node is ready."