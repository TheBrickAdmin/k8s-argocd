# Connect to the control node
vagrant ssh control-plane # Password: vagrant

    # Get information about the cluster
    kubectl get nodes

    # Get the pods in the default namespace
    kubectl get pods

    # Get the namespaces in the cluster
    kubectl get namespaces

    # Get the services in the default namespace
    kubectl get services

    # Get more details about the control node
    kubectl describe node node-01

    # There are 12 pods on the control node, try to find them
        # If you are not sure about the options of kubectl use 'kubectl --help'
        # Or if you know you want help about a specific command, use 'kubectl <command> --help'
        # E.g. 'kubectl get pods --help'
        # To get options for all kubectl commands use 'kubectl options'
    <#your code here#>

    # Which Image version of the kube-apiserver is running for the container in the kube-apiserver-control-plane pod?
    <#your code here#>