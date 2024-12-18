# Helm Chart Deployment for Nginx

## Objective
This task involves creating a Helm chart for deploying an Nginx server in a Kubernetes cluster, verifying the deployment, accessing the Nginx server, and deleting the release.

---

## 1. Prerequisites
Ensure the following tools are installed and configured:
- Kubernetes Cluster (e.g., Minikube, AKS, or GKE) we will use AKS 
- `kubectl` CLI
- Helm (v3 or later)

Verify Helm installation:
```bash
helm version
```
Verify Kubernetes cluster access:
```bash
kubectl get nodes
```

---

## 2. Create a New Helm Chart for Nginx
1. Create a new Helm chart named `nginx-chart`:
   ```bash
   helm create nginx-chart
   ```

2. Modify the default configuration for Nginx:
   - Open the **values.yaml** file under `nginx-chart` and update as needed:
     ```yaml
     replicaCount: 2
     image:
       repository: nginx
       tag: latest
       pullPolicy: IfNotPresent
     service:
       type: ClusterIP
       port: 80
     ```

3. Package the Helm chart (optional):
   ```bash
   helm package nginx-chart
   ```

---

## 3. Deploy the Helm Chart
Deploy the Helm chart to the Kubernetes cluster:

```bash
helm install nginx-release ./nginx-chart
```

### Verify the Deployment
Check the Helm release:
```bash
helm list
```

Verify the Nginx pods are running:
```bash
kubectl get pods
```

Check the Nginx service:
```bash
kubectl get svc
```

---

## 4. Access the Nginx Server
### Option 1: Port Forwarding
Forward a port from your local machine to the Nginx service:
```bash
kubectl port-forward svc/nginx-release 8080:80
```
Access Nginx in your browser at:
```
http://localhost:8080
```

### Option 2: NodePort (Optional)
If you update the service type to `NodePort` in `values.yaml`, access the service:
```bash
kubectl get svc
```
Locate the `NodePort` and access it at:
```
http://<NodeIP>:<NodePort>
```

---

## 5. Delete the Nginx Release
To clean up the resources, delete the Helm release:
```bash
helm uninstall nginx-release
```

Verify the release is deleted:
```bash
helm list
```
Check that no pods or services remain:
```bash
kubectl get all
```

---

## Summary
In this task, you:
1. Created a new Helm chart for Nginx.
2. Deployed the chart and verified the deployment.
3. Accessed the Nginx server.
4. Deleted the Nginx Helm release.

This process demonstrates the flexibility and power of Helm for managing Kubernetes applications.
