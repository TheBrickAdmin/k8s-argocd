# Kubernetes Application Management Advanced Challenges

## Prerequisites
- Running Kubernetes cluster with ArgoCD installed
- Access to GitHub repository with the example voting app
- ArgoCD CLI and kubectl configured

---

## Challenge 1: Branch-Based GitOps Workflow

### Create a New Branch
For the next challenges, create and checkout a branch so you can test while keeping the source intact.

```bash
# Create and switch to a new branch
git checkout -b feature/postgres-upgrade

# Push the branch to remote
git push -u origin feature/postgres-upgrade
```

### Deploy Application via ArgoCD
Create a new application in ArgoCD using the web UI with the following configuration:

1. Open the ArgoCD web interface
2. Click **+ NEW APP** 
3. Configure the application with these settings:
   - **Application Name**: `example-voting-app-branch`
   - **Project**: `default`
   - **Sync Policy**: `Manual`
   - **Auto-Create Namespace**: `Enabled`
   - **Repository URL**: `https://github.com/TheBrickAdmin/k8s-argocd` (or your forked repository)
   - **Revision**: `feature/postgres-upgrade` (your branch name)
   - **Path**: `apps/example-voting-app`
   - **Cluster**: `https://kubernetes.default.svc`
   - **Namespace**: `default`
4. Click **CREATE** to create the application
5. Click **SYNC** to deploy the voting app
6. Wait for the deployment to show **Healthy** and **Synced** status

---

## Challenge 2: Image Version Update and Testing

### **Update the PostgreSQL Image**
Find a supported PostgreSQL container version on [Docker Hub](https://hub.docker.com/_/postgres).

Update the PostgreSQL image in `apps/example-voting-app/db-deployment.yaml` to a recent version, e.g. `postgres:18-alpine`.

# Edit the deployment file
Edit file 'apps/example-voting-app/db-deployment.yaml'

Change the image line to:
    image: postgres:18-alpine

Commit and push the changes to your branch.

### Sync Application in ArgoCD
1. Use the **REFRESH** button in ArgoCD UI to check for your changes
2. The status of your application should change to **OutOfSync**
3. Click **SYNC** to bring your application back into sync
4. Monitor the sync progress in the UI

---

## Challenge 3: Troubleshooting Failed Deployments

### Fix the PostgreSQL 18 Error
The pod will fail to start with PostgreSQL 18. From PostgreSQL 18 onwards, there are stricter requirements for the data directory mount point.

**Option 1: Downgrade the image**
Edit file 'apps/example-voting-app/db-deployment.yaml'

Change the image line to:
    image: postgres:17-alpine

Commit and push the changes to your branch.

### Sync Application in ArgoCD
1. Use the **REFRESH** button in ArgoCD UI to check for your changes
2. The status of your application should change to **OutOfSync**
3. Click **SYNC** to bring your application back into sync
4. Monitor the sync progress in the UI

### Quick Rollback Method
Another way to quickly resolve the issue is to perform a rollback:

1. Open the application in ArgoCD UI
2. Select **HISTORY AND ROLLBACK**
3. Select a previous working revision to rollback to
4. Click **ROLLBACK** to perform the rollback

---

## Cleanup

After completing the challenges, clean up your environment:

### 1. Delete ArgoCD Application
1. Open the ArgoCD web interface
2. Select your `example-voting-app-branch` application
3. Click **DELETE**
4. Type the application name to confirm deletion
5. Click **DELETE** to confirm

### 2. Clean Up Git Branch
```bash
# Switch back to main branch
git checkout main

# Delete the local feature branch
git branch -D feature/postgres-upgrade

# Delete the remote feature branch
git push origin --delete feature/postgres-upgrade
```

This ensures your environment is clean for future exercises.