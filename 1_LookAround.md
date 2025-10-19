# Kubernetes Cluster Exploration Guide

This guide walks through exploring and inspecting your Kubernetes cluster to understand its components and configuration.

Several different formatting options are shown here. Be sure to learn at least one of the following before attempting a Kubernetes exam:
- custom_columns
- jsonpath

## Prerequisites
- A running Kubernetes cluster created with Vagrant
- Access to the control-plane node

## Exploration Steps

### 1. Connect to Control Plane
```bash
# Connect to the control node
vagrant ssh control-plane
```
**Password:** `vagrant`

### 2. Get Basic Cluster Information
```bash
# Get information about the cluster
kubectl get nodes

# Get the pods in the default namespace
kubectl get pods

# Get the namespaces in the cluster
kubectl get namespaces

# Get the services in the default namespace
kubectl get services
```

### 3. Inspect Node Details
```bash
# Get more details about the control node
kubectl describe node control-plane
```

### 4. Find All Pods on the Control Node
The control plane typically runs system pods in the `kube-system` namespace. Here are commands to explore:

```bash
# Get all pods across all namespaces
kubectl get pods --all-namespaces

# Get pods specifically in the kube-system namespace
kubectl get pods -n kube-system

# Get pods with more details (shows which node they're running on)
kubectl get pods --all-namespaces -o wide
```

### 5. Get Help Information
```bash
# General kubectl help
kubectl --help

# Help for specific commands
kubectl get pods --help

# Get options for all kubectl commands
kubectl options
```

### 6. Inspect kube-apiserver Pod Details
```bash
# Get detailed information about the kube-apiserver pod
kubectl describe pod kube-apiserver-control-plane -n kube-system

# Get just the image version of the kube-apiserver container
kubectl get pod kube-apiserver-control-plane -n kube-system -o jsonpath='{.spec.containers[0].image}'

# Alternative: Get YAML output to see all container details and filter using grep
kubectl get pod kube-apiserver-control-plane -n kube-system -o yaml | grep image:
```