#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y socat conntrack

# Enable bridge netfilter
sudo modprobe br_netfilter
sudo sh -c 'echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables'
sudo sh -c 'echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables'

# Make bridge netfilter settings persistent
sudo sh -c 'echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf'
sudo sysctl -p

# Delete any existing minikube cluster
sudo minikube delete

# Start minikube with specific Kubernetes version
sudo minikube start --vm-driver=none --kubernetes-version=v1.23.7

# Verify installation
kubectl get nodes