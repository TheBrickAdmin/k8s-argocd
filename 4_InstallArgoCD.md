# Install ArgoCD on Kubernetes

This guide walks through installing ArgoCD on your Kubernetes cluster and setting up access to the ArgoCD UI and CLI.

## Prerequisites
- A running Kubernetes cluster
- `kubectl` configured to access your cluster
- `curl` available for downloading the ArgoCD CLI

## Installation Steps

### 1. Create ArgoCD Namespace and Install
```bash
# Create the argocd namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Wait for ArgoCD to be Ready
```bash
# Wait for ArgoCD pods to be ready (timeout after 5 minutes)
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s
```

### 3. Expose ArgoCD Server
```bash
# Create a NodePort service for Argo CD server
kubectl expose -n argocd deployment argocd-server --type NodePort --name argocd-server-nodeport
```

### 4. Get Connection Details
```bash
# Get the IP of a node and the NodePort assigned to the Argo CD server
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].metadata.annotations.flannel\.alpha\.coreos\.com/public-ip}')
ARGOCD_NODEPORT=$(kubectl get svc -n argocd argocd-server-nodeport -o jsonpath='{.spec.ports[0].nodePort}')

# Output the connection details
echo "Argo CD Server is accessible at https://${NODE_IP}:${ARGOCD_NODEPORT}"
```

**Note:** Be sure to accept the self-signed certificate when opening it in a web browser.

### 5. Retrieve Admin Password
```bash
# Retrieve the initial password for the admin user
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

**Login Credentials**
- **Username:** `admin`
- **Password:** Use the password retrieved from the command above

## Install ArgoCD CLI

### 6. Download and Install ArgoCD CLI
```bash
# Install Argo CD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

### 7. Login to ArgoCD CLI
```bash
# Login to Argo CD CLI
argocd login "${NODE_IP}:${ARGOCD_NODEPORT}"
```

**Login prompts:**
- Accept the self-signed certificate when prompted
- **Username:** `admin`
- **Password:** Use the password retrieved earlier