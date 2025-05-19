# Clone the repository
git clone 

# Change to the directory
cd methos_k8s

# Create the cluster
vagrant up
# Wait for the cluster to deploy.
# Most likely choose which network interface to use (both for control-plane and worker nodes)

# Reboot the VMs
vagrant reload
# Wait for the VMs to come back up
# Most likely choose which network interface to use (both for control-plane and worker nodes)

# Connect to the control node (use a seperate terminal)
vagrant ssh control-plane # Password: vagrant

    # Get the IP address of the control node (eth0)
    CONTROLIP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

    # Deploy the Kubernetes cluster using kubeadm
    sudo kubeadm init --apiserver-advertise-address=$CONTROLIP --pod-network-cidr=10.244.0.0/16
    # Save the output of the above command starting with 'kubeadm join' for later use

    # Set up the kubeconfig file for the current user
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # Install a network plugin (Flannel)
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

    # Ignore these steps if you have saved the kubeadm join command
        # Get the token for the worker nodes (save it for later)
        kubeadm token list | grep 'default bootstrap' | awk '{print $1}'
        # Get the hash for the worker nodes (save it for later)
        openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
        # Echo the control node IP address (save it for later)
        echo $CONTROLIP

# Reboot the control node
vagrant reload control-plane
# Most likely choose which network interface to use

# Wait for the control node to come back up
vagrant ssh control-plane # Password: vagrant

# Start 2 new parallel terminal sessions
# Connect to the worker nodes
vagrant ssh node-01 # Password: vagrant
vagrant ssh node-02 # Password: vagrant

    # Join the worker node to the cluster (use the token and control node IP address from above) 
    # or the command saved in the kubeadm init output
    sudo kubeadm join <controlip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>