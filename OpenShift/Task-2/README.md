# Task 2: Deployment vs. StatefulSet

## Comparison between Deployment and StatefulSet

| **Feature**                   | **Deployment**                                          | **StatefulSet**                                    |
|-------------------------------|--------------------------------------------------------|---------------------------------------------------|
| **Purpose**                   | Used for stateless applications.                      | Used for stateful applications requiring stable storage and network identities. |
| **Pod Identity**              | Pods are interchangeable; no specific identity.       | Pods have a stable, unique identity (ordinal index). |
| **Storage**                   | Volumes are ephemeral by default.                     | Persistent volumes are retained even after Pod deletion. |
| **Scaling Behavior**          | Fast scaling as all Pods are identical.               | Slower scaling as Pods maintain identity.         |
| **Use Cases**                 | Web servers, APIs, stateless apps.                   | Databases, message queues, or other stateful workloads. |
| **Networking**                | Uses a single service for all Pods.                   | Each Pod gets a unique DNS name via a Headless Service. |

## YAML File: MySQL StatefulSet Configuration

Below is a sample YAML configuration for deploying MySQL as a StatefulSet.

### `mysql-statefulset.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  serviceName: "mysql"
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
          name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "rootpassword"
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

### Key Notes:
- **StatefulSet** ensures each MySQL Pod gets a unique identity (e.g., `mysql-0`, `mysql-1`, etc.).
- Persistent Volumes are provisioned for each replica via `volumeClaimTemplates`.
- MySQL password is set using the `MYSQL_ROOT_PASSWORD` environment variable.

---

## YAML File: Service for MySQL StatefulSet

This YAML defines a headless service for the MySQL StatefulSet to allow stable DNS names.

### `mysql-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None  # Headless service
  selector:
    app: mysql
```

### Key Notes:
- **Headless Service** (`clusterIP: None`) allows Pods to have individual DNS names (`mysql-0`, `mysql-1`, etc.).
- The service targets Pods with the label `app: mysql`.

---

## Steps to Deploy MySQL StatefulSet in Kubernetes/OpenShift

1. **Create MySQL StatefulSet**:
   - Apply the StatefulSet YAML file to create MySQL Pods with persistent storage.
   ```bash
   kubectl apply -f mysql-statefulset.yaml
   ```

2. **Create Headless Service**:
   - Apply the Service YAML file to expose the StatefulSet.
   ```bash
   kubectl apply -f mysql-service.yaml
   ```

3. **Verify the StatefulSet and Service**:
   - Check the status of the StatefulSet:
     ```bash
     kubectl get statefulset
     ```
   - Verify the Pods and their unique names:
     ```bash
     kubectl get pods
     ```
   - Confirm the headless service:
     ```bash
     kubectl get svc
     ```

4. **Access MySQL**:
   - Port forward a specific MySQL Pod to access it locally:
     ```bash
     kubectl port-forward mysql-0 3306:3306
     ```
   - Use a MySQL client to connect using:
     ```
     host: localhost
     port: 3306
     user: root
     password: rootpassword
     ```

5. **Monitor Persistent Storage**:
   - Check Persistent Volume Claims (PVCs) created for each Pod:
     ```bash
     kubectl get pvc
     ```
   - Verify data persistence by deleting a Pod and observing that data is retained after restart:
     ```bash
     kubectl delete pod mysql-0
     ```

---

## Conclusion
This task demonstrates the use of StatefulSet for deploying a stateful application (MySQL) with persistent storage. The headless service ensures stable DNS names for each replica, enabling reliable access to individual MySQL instances.
