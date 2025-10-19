# Kubernetes Lab Setup Guide

This guide walks through setting up a Kubernetes cluster using Vagrant and kubeadm.

## Prerequisites
- Windows machine with administrator privileges
- Vagrant installed
- Git installed
- Hyper-V

## Setup Steps

### 1. Clone Repository and Navigate to Directory
```bash
# Clone the repository
git clone https://github.com/TheBrickAdmin/k8s-argocd.git

# Change to the directory
cd k8s-argocd
```

### 2. Create and Start the Cluster
```bash
# Create the cluster
vagrant up
```
**Wait for the cluster to deploy.**

### 3. Reboot VMs
```bash
# Reboot the VMs
vagrant reload
```
**Wait for the VMs to come back up.**

### 4. Connect to Control Plane (Use a separate terminal)
```bash
# Connect to the control node
vagrant ssh control-plane
```
**Password:** `vagrant`

### 5. Initialize Kubernetes Cluster (Inside control-plane VM)
```bash
# Get the IP address of the control node (eth0)
CONTROLIP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Deploy the Kubernetes cluster using kubeadm
sudo kubeadm init --apiserver-advertise-address=$CONTROLIP --pod-network-cidr=10.244.0.0/16
```
**Important:** Save the output of the above command starting with `kubeadm join` for later use.

### 6. Configure kubectl Access
```bash
# Set up the kubeconfig file for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 7. Install Network Plugin
```bash
# Install a network plugin (Flannel)
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

### 8. Get Join Information (Alternative Method)
If you didn't save the `kubeadm join` command from step 5, use these commands:

```bash
# Get the token for the worker nodes (save it for later)
kubeadm token list | grep 'default bootstrap' | awk '{print $1}'

# Get the hash for the worker nodes (save it for later)
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

# Echo the control node IP address (save it for later)
echo $CONTROLIP
```

### 9. Reboot Control Plane
```bash
# Exit control-plane SSH session first
exit

# Reboot the control node
vagrant reload control-plane
```

### 10. Reconnect to Control Plane
```bash
# Wait for the control node to come back up
vagrant ssh control-plane
```
**Password:** `vagrant`

### 11. Connect to Worker Nodes (Use 2 separate terminal sessions)
**Terminal 1:**
```bash
# Connect to the first worker node
vagrant ssh node-01
```
**Password:** `vagrant`

**Terminal 2:**
```bash
# Connect to the second worker node
vagrant ssh node-02
```
**Password:** `vagrant`

### 12. Join Worker Nodes to Cluster
Run this command on **both** worker nodes (node-01 and node-02):

```bash
# Join the worker node to the cluster
# Replace <controlip>, <token>, and <hash> with actual values from steps 5 or 8
sudo kubeadm join <controlip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

**Example:**
```bash
sudo kubeadm join 192.168.1.100:6443 --token abc123.xyz789def456 --discovery-token-ca-cert-hash sha256:abcd1234ef567890...
```

## Verification

After completing the setup, verify your cluster is working:

```bash
# From the control-plane node
kubectl get nodes
kubectl get pods --all-namespaces
```

You should see all nodes in "Ready" status and all system pods running.

## Troubleshooting

- If VMs fail to start, ensure Hyper-V/VirtualBox is properly configured
- If `kubeadm init` fails, check IP addresses and network connectivity
- If worker nodes fail to join, verify the token, hash, and control plane IP are correct
- If pods are not starting, check the network plugin installation

## Next Steps

After your cluster is ready, you can:
- Deploy applications to your cluster
- Install additional tools like ArgoCD
- Set up monitoring and logging solutions