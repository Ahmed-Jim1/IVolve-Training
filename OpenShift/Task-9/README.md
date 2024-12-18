# Deploying NGINX Server Using Helm Chart on Azure Kubernetes Service (AKS)

## Pre-requisites

1. **Azure Kubernetes Service (AKS) Cluster**
   - Create an AKS cluster if not already done:
     ```bash
     az aks create --resource-group <resource-group> --name <aks-cluster> --node-count 2 --enable-addons monitoring --generate-ssh-keys
     ```
![image](https://github.com/user-attachments/assets/122cb4d2-a701-48f9-83f4-60c41dc5c21d)

     
2. **Helm installed locally**
   - Verify Helm installation:
     ```bash
     helm version
     ```
3. **kubectl configured to access AKS**
   - Connect `kubectl` to your AKS cluster:
     ```bash
     az aks get-credentials --resource-group <resource-group> --name <aks-cluster>
     ```

---

## 1. Create a New Helm Chart for NGINX

1. **Create a Helm Chart:**
   Run the following command to scaffold a basic Helm chart:
   ```bash
   helm create nginx-chart
   ```
   This generates the following directory structure:

![image](https://github.com/user-attachments/assets/0e4b093a-c568-4c22-b923-5f7bdf6d6814)


2. **Update the `values.yaml` file:**
   Modify the configuration to define your NGINX deployment:
   ```yaml
   replicaCount: 2

   image:
     repository: nginx
     tag: latest
     pullPolicy: IfNotPresent

   service:
     type: LoadBalancer 
     port: 80

   ingress:
     enabled: false
   ```
   - **`replicaCount`**: Number of NGINX pods to run.
   - **`service.type`**: `LoadBalancer` exposes the NGINX service externally.

---

## 2. Deploy the Helm Chart to AKS

1. **Deploy the Helm Chart:**
   Run the following command:
   ```bash
   helm install nginx-release ./nginx-chart
   ```
   ![image](https://github.com/user-attachments/assets/89bb4d5b-4893-4dbc-8db5-a4a96a55acf7)

   - `nginx-release`: Name of the Helm release.
   - `./nginx-chart`: Path to the Helm chart.



2. **Verify the Deployment:**
   - Check Helm releases:
     ```bash
     helm list
     ```
     ![image](https://github.com/user-attachments/assets/982e4bc5-352b-4c6a-96fc-360f85ceea77)

   - Verify the NGINX pods:
     ```bash
     kubectl get pods
     ```
   - Verify the NGINX service:
     ```bash
     kubectl get services
     ```
![image](https://github.com/user-attachments/assets/c9504807-8740-489e-b278-0fd873691bee)


---

## 3. Access the NGINX Server

1. **Find the External IP:**
   - From the `kubectl get services` output, note the `EXTERNAL-IP` of the LoadBalancer.

2. **Access the NGINX server:**
   - Use the External IP in a browser or with `curl`:
     ```bash
     curl http://<EXTERNAL-IP>
     ```
     Example:
     ```bash
     http://52.185.123.45
     ```
   You should see the default "Welcome to NGINX" page.

![image](https://github.com/user-attachments/assets/23cb9811-64ee-4f3e-a7cf-f0aa6821e924)


---

## 4. Delete the NGINX Release

1. **Uninstall the Helm release:**
   Run the following command to clean up resources:
   ```bash
   helm uninstall nginx-release
   ```

2. **Verify Cleanup:**
   - Check that the Helm release is deleted:
     ```bash
     helm list
     ```
   - Confirm that the pods and services are gone:
     ```bash
     kubectl get pods
     kubectl get services
     ```

---

## Summary of Commands

| **Task**                          | **Command**                          |
|-----------------------------------|--------------------------------------|
| Create Helm chart                 | `helm create nginx-chart`            |
| Deploy the Helm chart             | `helm install nginx-release ./nginx-chart` |
| Check deployment status           | `kubectl get pods`                   |
| Check services                    | `kubectl get services`               |
| Access NGINX server               | `curl http://<EXTERNAL-IP>`          |
| Delete Helm release               | `helm uninstall nginx-release`       |

---

## Why Helm is Useful in AKS?

1. **Simplified Deployment**: Helm simplifies deploying and managing Kubernetes applications.
2. **Reusable Templates**: Helm charts allow you to reuse configurations for similar deployments.
3. **Version Control**: Helm tracks chart versions, enabling rollbacks and upgrades.

---

## Final Notes
By following these steps, you successfully:
1. Created a Helm chart for NGINX.
2. Deployed it in an AKS cluster.
3. Verified its accessibility.
4. Cleaned up resources efficiently.

This workflow demonstrates the power of Helm in Kubernetes for managing applications seamlessly in cloud environments.
