# Connect to the control node
vagrant ssh control-plane # Password: vagrant

    ## Issues will occur, simulate an error by destroying a pod
    # Get the status of the pods
    kubectl get pods
    # Choose a pod to destroy and destroy it
    # E.g. kubectl delete pod vote-69cb46f6fb-p628f
    kubectl delete pod <pod-name>
    # Check the status of the pods again
    kubectl get pods

    ## Load may increase, scale the deployment
    # Check the status of the deployments
    kubectl get deployments
    # Scale the number of replicas of the vote deployment to 3
    kubectl scale deployment vote --replicas=3
    # Check the status of the deployments again
    kubectl get deployments

    ## Scaling will not persist after a reboot
    # Simulate a reboot by reapplying all deployments
    cd ~/example-voting-app/k8s-specifications
    kubectl apply -f .
    # Check the status of the deployments again
    kubectl get deployments
    # Scale the number of replicas of the vote deployment to 5
    vi vote-deployment.yaml
    # Change the number of replicas to 5
    # Save and exit the file
    # Reapply the deployment
    kubectl apply -f vote-deployment.yaml
    # Check the status of the deployments again
    kubectl get deployments

    ## An intern has deleted one of the deployment files, recreate them
    rm worker-deployment.yaml
    # Recreate the deployment
    kubectl get deployment worker -o yaml > worker-deployment.yaml
    # Cleanup the deployment
    vi worker-deployment.yaml
    # Remove the following fields:
        # annotations
        # creationTimestamp
        # generation
        # resourceVersion
        # uid
        # status
    # Save and exit the file
    # Reapply the deployment
    kubectl apply -f worker-deployment.yaml

    # Play around with the cluster
    # When done, exit the control node
    exit

# Stop the cluster
vagrant halt
# Optionally destroy the cluster
vagrant destroy