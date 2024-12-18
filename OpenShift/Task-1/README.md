# Task 1: Updating Applications and Rolling Back Changes Using OpenShift

This task demonstrates deploying, updating, and rolling back applications using OpenShift. The goal is to deploy NGINX, update it to Apache, and roll back the deployment to the previous version.

## **Task Overview**

1. Deploy **NGINX** with 3 replicas in OpenShift.
2. Expose the NGINX deployment as a service.
3. Access the NGINX service locally using port forwarding.
4. Update the NGINX deployment to use the **Apache** image.
5. View the rollout history of the deployment.
6. Roll back the deployment to the previous image version.
7. Monitor the pod status to confirm a successful rollback.

---

## **Prerequisites**
- OpenShift CLI (`oc`) installed.
- Access to an OpenShift cluster.
- A user account with sufficient permissions to create deployments and services.

---

## **Steps**

### **1. Deploy NGINX with 3 Replicas**
Run the following command to create the NGINX deployment:

```bash
oc create deployment nginx-deployment --image=nginx 
oc scale deployment nginx-deployment --replicas=3
```

Verify the deployment:
```bash
oc get deployments
oc get pods
```
![image](https://github.com/user-attachments/assets/ff9d2982-86bb-465d-8a83-3e42ca381eb1)

---

### **2. Expose the NGINX Deployment**
Expose the deployment as a service to make it accessible:

```bash
oc expose deployment nginx-deployment --port=80 --type=ClusterIP
```

Verify the service:
```bash
oc get services
```
![image](https://github.com/user-attachments/assets/f6597129-276c-474d-a128-15ec565179e3)

---

### **3. Port Forward to Access NGINX Locally**
Use port forwarding to access the NGINX service on your local machine:

```bash
oc port-forward svc/nginx-deployment 8080:80
```

Now open a browser and visit:
```
http://localhost:8080
```
You should see the NGINX welcome page.

---

### **4. Update the NGINX Image to Apache**
Update the deployment to use the **Apache HTTPD** image:

```bash
oc set image deployment/nginx-deployment nginx=httpd
```

Verify the updated pods:
```bash
oc get pods
```
Check the status of the rollout:
```bash
oc rollout status deployment/nginx-deployment
```

---

### **5. View Deployment Rollout History**
View the deployment's rollout history to check previous revisions:

```bash
oc rollout history deployment/nginx-deployment
```
![image](https://github.com/user-attachments/assets/b230557e-4ce8-4117-856d-3f82cd5d3650)

---

### **6. Roll Back the Deployment**
Roll back the deployment to the previous version (NGINX):

```bash
oc rollout undo deployment/nginx-deployment
```

Verify the rollback:
```bash
oc rollout status deployment/nginx-deployment
oc get pods
```
Ensure that the pods are running the NGINX image again.

---

### **7. Monitor Pod Status**
Check the pods' status to confirm a successful rollback:

```bash
oc describe pods
oc get pods
```

---

## **Summary**
- Deployed NGINX with 3 replicas.
- Exposed the deployment using a service and accessed it locally.
- Updated the deployment to use Apache HTTPD.
- Viewed the rollout history and rolled back to the previous version.
- Monitored the pod status to confirm a successful rollback.

---

## **Commands Reference**
| **Task**                          | **Command**                                                |
|-----------------------------------|-----------------------------------------------------------|
| Create deployment                 | `oc create deployment nginx-deployment --image=nginx`     |
| Expose deployment                 | `oc expose deployment nginx-deployment --port=80`         |
| Port forward service              | `oc port-forward svc/nginx-deployment 8080:80`            |
| Update deployment image           | `oc set image deployment/nginx-deployment nginx=httpd`    |
| Check rollout status              | `oc rollout status deployment/nginx-deployment`           |
| View rollout history              | `oc rollout history deployment/nginx-deployment`          |
| Roll back deployment              | `oc rollout undo deployment/nginx-deployment`             |
| Check pods                        | `oc get pods`                                             |

---

## **Conclusion**
This task demonstrates how to manage application updates and rollbacks in OpenShift. Rolling back deployments ensures minimal downtime and a reliable way to restore previous versions during failures or issues.
