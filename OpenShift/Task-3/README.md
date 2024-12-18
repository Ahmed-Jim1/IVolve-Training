# Task 3: Multi-container Applications in AKS

## Objective
Create a Kubernetes deployment for NGINX with an init container that sleeps for 10 seconds before NGINX starts. Use readiness and liveness probes to monitor NGINX health. Create a LoadBalancer Service to expose the NGINX application. Verify that the init container runs successfully, and NGINX initializes properly.

### Key Concepts:
- **Readiness vs Liveness Probes**: Health checks for containers.
- **Init Containers vs Sidecar Containers**: Different container roles in a pod.

---

## Step 1: Prepare AKS

Make sure you have the following in place:

1. **AKS Cluster**: A running AKS cluster.
2. **kubectl configured**: Verify that you are connected to the AKS cluster:

   ```bash
   kubectl get nodes
   ```

---

## Step 2: Create the Deployment for NGINX

### 1. Write the Deployment YAML File

Create a file named `nginx-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      # Init container that runs before the main container
      initContainers:
        - name: init-sleep
          image: busybox
          command: ['sh', '-c', 'echo "Initializing..."; sleep 10']
      # Main container (NGINX)
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
          # Liveness Probe: Check if NGINX is alive
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          # Readiness Probe: Check if NGINX is ready to serve traffic
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
```

**Explanation:**
- **Init Container**: Sleeps for 10 seconds (`busybox`) to simulate initialization tasks.
- **Liveness Probe**: Verifies the NGINX server is still alive.
- **Readiness Probe**: Checks that NGINX is ready to serve traffic.
- **Initial Delay**: Ensures probes don't start until the application has time to initialize.

---

## Step 3: Expose NGINX Using a LoadBalancer Service

Create a file named `nginx-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
```

**Explanation:**
- **LoadBalancer**: Exposes the NGINX application externally via a cloud provider's load balancer.

---

## Step 4: Deploy to AKS

### 1. Apply the Deployment:

```bash
kubectl apply -f nginx-deployment.yaml
```

### 2. Apply the LoadBalancer Service:

```bash
kubectl apply -f nginx-service.yaml
```

### 3. Verify the Resources:

Check the pods:

```bash
kubectl get pods
```

Check the services:

```bash
kubectl get services
```

### 4. Check Init Container Status:

```bash
kubectl describe pod <pod-name>
```

---

## Step 5: Access NGINX

Find the **External IP** of the LoadBalancer service:

```bash
kubectl get services
```

Example output:

```bash
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nginx-service   LoadBalancer   10.0.183.42    52.185.123.45   80:30201/TCP   2m
```

Access NGINX using the **External IP**:

```bash
curl http://<EXTERNAL-IP>
```

Alternatively, open the browser and visit:

```
http://<EXTERNAL-IP>
```

---

## Step 6: Verify Health Probes

Check the readiness and liveness probes:

```bash
kubectl describe pod <pod-name>
```

Look for probe-related events in the logs.

---

## Step 7: Differences

### 1. Readiness Probe vs Liveness Probe

| Aspect              | Readiness Probe                        | Liveness Probe                        |
|---------------------|----------------------------------------|---------------------------------------|
| **Purpose**         | Checks if the container is ready to serve traffic. | Checks if the container is alive and healthy. |
| **Impact of Failure** | Pod stops receiving traffic.          | Kubernetes restarts the container.    |
| **Example**         | App waiting for a DB connection.       | App stuck or unresponsive.            |

### 2. Init Container vs Sidecar Container

| Aspect               | Init Container                       | Sidecar Container                     |
|----------------------|--------------------------------------|---------------------------------------|
| **Purpose**          | Runs setup or initialization tasks before the main container starts. | Runs alongside the main container for extended functionality. |
| **Lifecycle**        | Runs once and exits.                 | Runs concurrently with the main container. |
| **Example Use Case** | Pre-populating data or waiting for dependencies. | Logging, monitoring, or proxy tasks.  |

---

## Summary

By completing this task, you will:

- Create a deployment for NGINX with an init container.
- Add readiness and liveness probes.
- Expose the service using **LoadBalancer**.
- Access and verify NGINX in the AKS cluster.
- Understand the differences between **readiness vs liveness probes** and **init vs sidecar containers**.

---

**End of Task 6** 🚀

