# Introduction
Fork this repository so you can make changes and test them out.
Solutions to challenges can be found in the 'solutions' directory.
These challenges should be performed in the GUI instead when stated otherwise.

# Challenge: Run the example voting app as an Argo CD application
Create a new application and use the following details:
- Application Name: example-voting-app
- Project: default
- Sync Policy: Manual
- Auto-Create Namespace: Enabled
- Repository URL: https://github.com/TheBrickAdmin/k8s-argocd (or use your own forked repository)
- Path: apps/example-voting-app
- Cluster: https://kubernetes.default.svc
- Namespace: default

After creating the application, sync it to deploy the voting app.
Wait for the deployment to show it is Healthy and Synced

# Accessing the application
Since the voting app uses a NodePort service, you can access it using the control plane node's IP and the NodePort assigned to the voting service.
Open a browser and navigate to http://<nodeport-ip>:31000 to show the voting page.
Open another tab and navigate to http://<nodeport-ip>:31001 to show the results page.
Cast your vote and see the result.