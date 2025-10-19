# Kubernetes Application Management Guide

This guide demonstrates common Kubernetes application management tasks including troubleshooting, scaling, and recovery operations.

## Prerequisites
- A running Kubernetes cluster with the example voting app deployed
- Access to the control-plane node

## Management Operations

### 1. Connect to Control Plane
```bash
# Connect to the control node
vagrant ssh control-plane
```
**Password:** `vagrant`

## Troubleshooting: Simulating and Recovering from Pod Failures

### 2. Simulate Pod Failure
Issues will occur in production. Let's simulate an error by destroying a pod and observe Kubernetes' self-healing capabilities.

```bash
# Get the status of the pods
kubectl get pods

# Choose a pod to destroy and destroy it
# Replace <pod-name> with an actual pod name from the output above
# Example: kubectl delete pod vote-69cb46f6fb-p628f
kubectl delete pod <pod-name>

# Check the status of the pods again
kubectl get pods
```

**Expected Result:** Kubernetes will automatically create a new pod to replace the deleted one, maintaining the desired state.

## Scaling: Handling Increased Load

### 3. Scale Deployment Dynamically
When load increases, you can scale deployments to handle more traffic.

```bash
# Check the status of the deployments
kubectl get deployments

# Scale the number of replicas of the vote deployment to 3
kubectl scale deployment vote --replicas=3

# Check the status of the deployments again
kubectl get deployments
```

### 4. Persistent Scaling Through Configuration
Dynamic scaling will not persist after redeployment. To make scaling persistent, modify the deployment YAML files.

```bash
# Navigate to the application directory
cd ~/example-voting-app/k8s-specifications

# Simulate a reboot by reapplying all deployments
kubectl apply -f .

# Check the status of the deployments again (scaling is lost)
kubectl get deployments

# Edit the vote deployment file to make scaling persistent
vi vote-deployment.yaml
```

**In the editor:**
- Find the line with `replicas:` 
- Change the number to `5`
- Save and exit the file (`:wq` in vi)

```bash
# Reapply the deployment with the new replica count
kubectl apply -f vote-deployment.yaml

# Check the status of the deployments again
kubectl get deployments
```

## Recovery: Recreating Lost Configuration Files

### 5. Simulate Accidental File Deletion
An intern has accidentally deleted one of the deployment files. Let's recreate it from the running deployment.

```bash
# Simulate accidental deletion
rm worker-deployment.yaml

# Recreate the deployment file from the running deployment
kubectl get deployment worker -o yaml > worker-deployment.yaml
```

### 6. Clean Up the Generated YAML
The generated YAML contains runtime fields that should be removed for clean deployment files.

```bash
# Edit the recreated deployment file
vi worker-deployment.yaml
```

**Remove the following fields from the YAML:**
- `metadata.annotations` (if present)
- `metadata.creationTimestamp`
- `metadata.generation`
- `metadata.resourceVersion`
- `metadata.uid`
- `status` (entire section at the bottom)

**Save and exit the file** (`:wq` in vi)

```bash
# Reapply the cleaned deployment
kubectl apply -f worker-deployment.yaml

# Verify the deployment is working
kubectl get deployments
kubectl get pods
```

## Experimentation and Exploration

### 7. Additional Operations to Try
```bash
# View deployment history
kubectl rollout history deployment vote

# Check resource usage (if metrics-server is installed)
kubectl top pods

# View logs from a specific pod
kubectl logs <pod-name>

# Execute commands inside a running pod
kubectl exec -it <pod-name> -- /bin/sh

# Get detailed information about a deployment
kubectl describe deployment vote

# Check service endpointslices (which endpoints are used by a service?)
kubectl get endpointslices
```