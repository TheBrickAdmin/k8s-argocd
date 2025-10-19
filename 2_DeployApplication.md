# Deploy Example Voting Application

This guide walks through deploying a sample voting application to your Kubernetes cluster and accessing it from your local machine.

## Prerequisites
- A running Kubernetes cluster with worker nodes joined
- Access to the control-plane node
- Git available on the control-plane node

## Deployment Steps

### 1. Connect to Control Plane
```bash
# Connect to the control node
vagrant ssh control-plane
```
**Password:** `vagrant`

### 2. Clone the Example Application Repository
```bash
# Clone the Repository
git clone https://github.com/dockersamples/example-voting-app.git
cd example-voting-app
```

### 3. Review the Kubernetes Manifests
```bash
# Review the Kubernetes Manifests
cd k8s-specifications
ls
```

```bash
# Open one of the YAML files to see the configuration
cat db-deployment.yaml
```

### 4. Deploy the Application
```bash
# Deploy the Application
kubectl apply -f .
```

### 5. Check Deployment Status
```bash
# Check the Status
kubectl get pods
kubectl get services
kubectl get endpointslices
```

### 6. Get Node IP Address
```bash
# Get the IP address of the control node (eth0)
ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1
```

### 7. Find NodePort Services and Access the Application
```bash
# Find services with NodePort type
kubectl get services --all-namespaces | grep NodePort

# Get detailed information about the voting app services
kubectl get services

# Find the NodePort for the vote service
VOTE_NODEPORT=$(kubectl get service vote -o jsonpath='{.spec.ports[0].nodePort}')

# Find the NodePort for the result service  
RESULT_NODEPORT=$(kubectl get service result -o jsonpath='{.spec.ports[0].nodePort}')

# Get the control plane IP
CONTROL_IP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Display access URLs
echo "Voting interface: http://${CONTROL_IP}:${VOTE_NODEPORT}"
echo "Results interface: http://${CONTROL_IP}:${RESULT_NODEPORT}"
```

## Application Components

The example voting app consists of several components:

- **Vote Service**: Frontend for casting votes
- **Result Service**: Frontend for viewing results  
- **Worker**: Background service processing votes
- **Redis**: In-memory database for vote queue
- **PostgreSQL**: Database for storing vote results

## Accessing the Application

After deployment, you can access:

1. **Voting Interface**: Cast your votes
2. **Results Interface**: View real-time voting results

The application uses NodePort services to expose the frontends outside the cluster.