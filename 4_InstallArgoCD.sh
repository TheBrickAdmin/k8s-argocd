# Create the argocd namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Verify the installation
# Wait for ArgoCD pods to be ready (timeout after 5 minutes)
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Create a NodePort service for Argo CD server
kubectl expose -n argocd deployment argocd-server --type NodePort --name argocd-server-nodeport

# Get the IP of a node and the NodePort assigned to the Argo CD server
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].metadata.annotations.flannel\.alpha\.coreos\.com/public-ip}')
ARGOCD_NODEPORT=$(kubectl get svc -n argocd argocd-server-nodeport -o jsonpath='{.spec.ports[0].nodePort}')

# Output the connection details. Be sure to accept the self-signed certificate when opening it a web browser.
echo "Argo CD Server is accessible at https://${NODE_IP}:${ARGOCD_NODEPORT}"

# Retrieve the initial password for the admin user
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo

# Login to Argo CD with the following details:
# Username: admin
# Password: (the password retrieved above)

# Install Argo CD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Login to Argo CD CLI
argocd login "${NODE_IP}:${ARGOCD_NODEPORT}"
# Accept the self-signed certificate when prompted
# Username: admin
# Password: (the password retrieved earlier)