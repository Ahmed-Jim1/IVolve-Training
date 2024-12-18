# Configuring a MySQL Pod Using ConfigMap and Secret

## Objective
The goal of this task is to configure a MySQL Pod in Kubernetes using **ConfigMap** and **Secret** to manage configuration values securely and efficiently.

---

## 1. Create a Namespace and Apply Resource Quota

### 1.1 Create the Namespace
Create a namespace `ivolve` to organize the resources.


```bash
kubectl create namespace ivolve

```


**Apply:**
```bash
kubectl apply -f namespace.yaml
```

---

### 1.2 Apply Resource Quota
Define a resource quota to limit resource usage.

**File:** `resource-quota.yaml`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ivolve-quota
  namespace: ivolve
spec:
  hard:
    pods: 2
```

**Apply:**
```bash
kubectl apply -f resource-quota.yaml
```

---

## 2. Create a ConfigMap for MySQL Configuration
Store the MySQL database name and user in a ConfigMap.

**File:** `mysql-config.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: ivolve
data:
  MYSQL_DATABASE: ivolve_db
  MYSQL_USER: ivolve_user
```

**Apply:**
```bash
kubectl apply -f mysql-config.yaml
```

---

## 3. Create a Secret for MySQL Passwords
Store the MySQL root password and user password securely.

**File:** `mysql-secret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: ivolve
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: YWhtZWQ=
  MYSQL_PASSWORD: YWhtZWQ=

```

### Generate Encoded Passwords
Run the following commands to base64 encode the passwords:

```bash
echo -n 'ahmed' | base64
echo -n 'ahmed' | base64
```
Replace the encoded values in `mysql-secret.yaml`.

**Apply:**
```bash
kubectl apply -f mysql-secret.yaml
```

---

## 4. Deploy MySQL with Resource Limits
Create a MySQL deployment with resource requests and limits.

**File:** `mysql-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: ivolve
  labels:
    app: mysql
spec:
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
        image: mysql:8.0
        env:
        - name: MYSQL_DATABASE
          valueFrom:
            configMapKeyRef:
              name: mysql-config
              key: MYSQL_DATABASE
        - name: MYSQL_USER
          valueFrom:
            configMapKeyRef:
              name: mysql-config
              key: MYSQL_USER
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_ROOT_PASSWORD
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_PASSWORD
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "1"
            memory: "2Gi"
        ports:
        - containerPort: 3306
```

**Apply:**
```bash
kubectl apply -f mysql-deployment.yaml
```

---

## 5. Verify the MySQL Pod and Configuration

### 5.1 Verify Pod Status
Check if the MySQL pod is running:

```bash
kubectl get pods -n ivolve
```

![image](https://github.com/user-attachments/assets/d4243afc-039f-426d-95dc-f6c7d23b3a79)



### 5.2 Exec into the MySQL Pod
Access the MySQL pod shell:

```bash
kubectl exec -it mysql-pod-name -n ivolve -- bash
```

![image](https://github.com/user-attachments/assets/bf3b96f2-8417-405a-9fbd-8d7e716cd09b)

### 5.3 Verify MySQL Configuration
Connect to MySQL:

```bash
mysql -u root -p
```
Enter the root password (from your Secret).

**Check the database and user:**

```sql
SHOW DATABASES;
SELECT User, Host FROM mysql.user;
```
![image](https://github.com/user-attachments/assets/cd2faa27-5d8c-436e-b114-ff649a5cdfb4) ![image](https://github.com/user-attachments/assets/13f1e57a-0142-4ac9-a29a-1e129a7fb9fe)


---

## Summary
This setup uses:
- **ConfigMap**: To store non-sensitive data (database name and user).
- **Secret**: To securely store passwords.
- **Resource Quota**: To limit resource usage in the namespace.
- **Deployment**: To deploy the MySQL container with resource requests and limits.

---

## Commands Recap

### Apply Namespace and Resource Quota:
```bash
kubectl apply -f namespace.yaml
kubectl apply -f resource-quota.yaml
```

### Apply ConfigMap and Secret:
```bash
kubectl apply -f mysql-config.yaml
kubectl apply -f mysql-secret.yaml
```

### Deploy MySQL:
```bash
kubectl apply -f mysql-deployment.yaml
```

### Verify:
```bash
kubectl get pods -n ivolve
kubectl exec -it <mysql-pod-name> -n ivolve -- bash
```

---

## Conclusion
This configuration demonstrates the use of **ConfigMap**, **Secrets**, and **Resource Limits** in Kubernetes to efficiently and securely deploy a MySQL Pod. The setup ensures secure password management and enforces resource usage constraints.

