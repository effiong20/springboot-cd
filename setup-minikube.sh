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

# Install crictl (required for Minikube)
VERSION="v1.28.0"
curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz --output crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Install conntrack (required for Minikube with --driver=none)
sudo apt install -y conntrack

# Stop any running minikube instances
sudo minikube stop || true
sudo minikube delete || true

# Start Minikube with docker driver (more reliable than none driver)
sudo -E minikube start --driver=docker

# Fix permissions for kubeconfig
mkdir -p $HOME/.kube
sudo cp -f $(sudo -E minikube kubectl -- config view --raw -o json | jq -r '.users[0].user."client-certificate"') $HOME/.minikube/profiles/minikube/client.crt
sudo cp -f $(sudo -E minikube kubectl -- config view --raw -o json | jq -r '.users[0].user."client-key"') $HOME/.minikube/profiles/minikube/client.key
sudo -E minikube update-context
sudo chown -R $(id -u):$(id -g) $HOME/.kube/ $HOME/.minikube/

# Set KUBECONFIG environment variable
echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
export KUBECONFIG=$HOME/.kube/config

# Verify cluster is running
kubectl cluster-info

echo "Minikube setup complete!"
echo "Run 'kubectl get nodes' to verify your node is ready."