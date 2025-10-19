# Connect to the control node
vagrant ssh control-plane # Password: vagrant

    # Clone the Repository
    git clone https://github.com/dockersamples/example-voting-app.git
    cd example-voting-app

    # Review the Kubernetes Manifests
    cd k8s-specifications
    ls
        # Open one of the YAML files to see the configuration
        cat db-deployment.yaml

    # Deploy the Application
    kubectl apply -f .

    # Check the Status
    kubectl get pods
    kubectl get services
    kubectl get endpointslices

    # Access the Application
    # Get the IP address of the control node (eth0)
    ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1
    # The application is accessible from a service of the type NodePort.
    # Try to find the port and access the application on http://<controlip>:<port>
    <#your code here#>

    
