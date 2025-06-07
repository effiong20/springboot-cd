#!/bin/bash

# Check if ArgoCD is installed
echo "Checking ArgoCD installation..."
kubectl get namespace argocd > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "ArgoCD namespace not found. Please install ArgoCD first."
  exit 1
fi

# Check ArgoCD pods
echo "Checking ArgoCD pods..."
kubectl get pods -n argocd

# Check ArgoCD services
echo "Checking ArgoCD services..."
kubectl get svc -n argocd

# Check if security group allows traffic
echo "Checking if port 31145 is open..."
nc -zv 18.208.147.179 31145 -w 5

# Fix ArgoCD service to use NodePort
echo "Updating ArgoCD service to use NodePort 31145..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "nodePort": 31145}]}}'

# Check if firewall is blocking traffic
echo "Checking firewall rules..."
sudo iptables -L | grep 31145

# Open port in firewall if needed
echo "Opening port 31145 in firewall..."
sudo iptables -A INPUT -p tcp --dport 31145 -j ACCEPT

# Get ArgoCD admin password
echo "ArgoCD admin credentials:"
echo "Username: admin"
echo "Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"

echo "Troubleshooting complete. Try accessing ArgoCD at http://18.208.147.179:31145/ again."