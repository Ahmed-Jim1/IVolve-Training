# Task 2: Jenkins Pipeline for Application Deployment

## Objective
Create a Jenkins pipeline that automates the following processes:
1. Build a Docker image from a Dockerfile stored in a GitHub repository.
2. Push the Docker image to Docker Hub.
3. Update the image reference in the `deployment.yaml` file.
4. Deploy the updated application to OpenShift.
5. Execute a post-action step in the pipeline.

---

## Repository
GitHub Repository: [Lab Repository](https://github.com/IbrahimAdell/Lab.git)

---

## Steps to Implement Jenkins Pipeline

### 1. Jenkins Pipeline Configuration
Create a Jenkinsfile in the GitHub repository that defines the pipeline stages for automation.

**Jenkinsfile**

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-app'
        DOCKER_HUB_REPO = 'your-dockerhub-username/my-app'
        DOCKER_CREDENTIALS = credentials('docker-credentials-id')
        OPENSHIFT_NAMESPACE = 'ivolve'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKER_HUB_REPO}:${env.BUILD_NUMBER}"
                    sh "docker push ${DOCKER_HUB_REPO}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Update Deployment File') {
            steps {
                script {
                    echo 'Updating deployment.yaml with new image...'
                    sh "sed -i 's|image: .*|image: ${DOCKER_HUB_REPO}:${env.BUILD_NUMBER}|g' deployment.yaml"
                }
            }
        }

        stage('Deploy to OpenShift') {
            steps {
                script {
                    echo 'Deploying to OpenShift...'
                    sh "oc apply -f deployment.yaml -n ${OPENSHIFT_NAMESPACE}"
                    sh "oc rollout status deployment/my-app -n ${OPENSHIFT_NAMESPACE}"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
```

---

### 2. Steps Explanation

1. **Checkout Code**:
   - Fetch the source code from the GitHub repository.

2. **Build Docker Image**:
   - Use the `docker build` command to create a Docker image from the `Dockerfile`.

3. **Push to Docker Hub**:
   - Authenticate to Docker Hub using Jenkins credentials.
   - Tag the Docker image with the current build number and push it to the repository.

4. **Update Deployment File**:
   - Modify the `image` field in the `deployment.yaml` file to use the newly built image.

5. **Deploy to OpenShift**:
   - Apply the updated `deployment.yaml` to the OpenShift cluster.
   - Verify the rollout status of the deployment.

6. **Post-Action**:
   - Print a success or failure message based on the pipeline execution status.

---

### 3. Prerequisites
1. **Jenkins Setup**:
   - Install Docker and OpenShift CLI (`oc`) on the Jenkins server.
   - Configure Jenkins credentials for Docker Hub (`docker-credentials-id`).
   - Add OpenShift cluster access to Jenkins.

2. **GitHub Repository**:
   - Ensure the repository contains a `Dockerfile` and `deployment.yaml`.

3. **OpenShift Namespace**:
   - Create a namespace for the deployment using:
     ```bash
     oc create namespace ivolve
     ```

---

### 4. Deployment File Example
Ensure the `deployment.yaml` file exists and uses the image field that can be updated.

**deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: ivolve
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: your-dockerhub-username/my-app:latest
        ports:
        - containerPort: 8080
```

---

### 5. Commands Recap
- **Run Pipeline**: Trigger the Jenkins pipeline job.
- **Verify Image**:
   ```bash
   docker images
   ```
- **Verify OpenShift Deployment**:
   ```bash
   oc get pods -n ivolve
   oc describe deployment my-app -n ivolve
   ```

---

## Summary
This Jenkins pipeline automates the CI/CD process by:
1. Building and pushing a Docker image to Docker Hub.
2. Updating the deployment file dynamically.
3. Deploying the application to OpenShift.
4. Including a post-action to notify on pipeline success or failure.

By following these steps, you ensure a streamlined and repeatable deployment process for your applications.

---

## Next Steps
- Integrate notifications (e.g., Slack) for pipeline status.
- Add automated testing stages for improved reliability.
- Implement resource limits and health checks in the deployment.yaml file.

