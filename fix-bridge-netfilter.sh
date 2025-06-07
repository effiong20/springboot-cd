#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y socat conntrack

# Create bridge module directory if it doesn't exist
sudo mkdir -p /proc/sys/net/bridge/

# Enable bridge netfilter
sudo modprobe br_netfilter
sudo sh -c 'echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables'
sudo sh -c 'echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables'

# Make bridge netfilter settings persistent
sudo sh -c 'echo "br_netfilter" >> /etc/modules'
sudo sh -c 'echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf'
sudo sysctl -p

echo "Bridge netfilter module enabled. Now try running minikube again."