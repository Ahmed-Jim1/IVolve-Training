# Task 3: Jenkins Shared Libraries

## Objective
Implement Jenkins shared libraries to reuse code across multiple pipelines. This ensures modularity, reusability, and cleaner pipeline definitions. The shared library will handle common tasks such as setting namespaces, building and pushing Docker images, and deploying to Kubernetes.

---

## Overview
Jenkins shared libraries allow developers to share reusable pipeline code across multiple Jenkinsfiles. This approach helps standardize pipeline tasks and avoid code duplication.

### Key Components of Shared Libraries
1. **vars/**: Contains global functions accessible within the pipeline.
2. **resources/**: Holds configuration files or templates.
3. **src/**: Stores Groovy classes for more advanced logic.

In this task:
- A shared library is created to manage common tasks.
- The library is demonstrated in two example pipelines to show its reusability.

---

## Steps to Implement Jenkins Shared Libraries

### 1. Create a Shared Library Repository
1. Create a GitHub repository to store the shared library.
2. Use the following directory structure:

```plaintext
shared-library/
├── vars
    ├── dockerTasks.groovy       # Docker-related tasks
    └── deployToKubernetes.groovy # Kubernetes deployment logic

this is the link for my repo >> https://github.com/Ahmed-Jim1/shared-library.git
```

---

### 2. Define the Shared Library Functions
#### **2.1 setNamespace.groovy** (vars/setNamespace.groovy)
This function maps branch names to Kubernetes namespaces.

```groovy
// vars/setNamespace.groovy

def call(String branchName) {
    def namespace = ""

    if (branchName.contains("Dev")) {
        namespace = "dev"
    } else if (branchName.contains("Test")) {
        namespace = "test"
    } else if (branchName == "main" || branchName.contains("Prod")) {
        namespace = "prod"
    } else {
        error "Branch name '${branchName}' does not match any known namespace"
    }
    
    echo "Deploying to namespace: ${namespace}"
    return namespace
}

```

#### **2.2 dockerTasks.groovy** (vars/dockerTasks.groovy)
This function handles Docker build, login, and push tasks.

```groovy
// vars/dockerTasks.groovy
def buildDockerImage(String imageName, String buildNumber) {
    echo "Building Docker image: ${imageName}:${buildNumber}..."
    sh """
        docker build -t ${imageName}:${buildNumber} .

    """
}

def dockerLogin(String username, String password) {
    echo "Logging in to Docker Hub..."
    sh """
        echo "${password}" | docker login -u "${username}" --password-stdin

    """
}

def pushDockerImage(String imageName, String buildNumber, String repoName) {
    echo "Tagging and pushing Docker image to Docker Hub..."
    sh """
        docker tag ${imageName}:${buildNumber} ${repoName}/${imageName}:latest
        docker push ${repoName}/${imageName}:latest

    """
}

def dockerCleanup() {
    echo "Cleaning up Docker images..."
    sh """
        docker logout
        docker image prune -f
        
    """
}

```

#### **2.3 deployToKubernetes.groovy** (vars/deployToKubernetes.groovy)
This function deploys an application to Kubernetes.

```groovy
// vars/deployToKubernetes.groovy

def call(String namespace) {
    // Use credentials to fetch the Kubernetes kubeconfig
    withCredentials([file(credentialsId: 'aks', variable: 'KUBECONFIG')]) {
        // Deploy to Kubernetes using the provided namespace
        sh """
            export KUBECONFIG=${KUBECONFIG}
            kubectl apply -f deployment.yaml --namespace=${namespace}
            kubectl get pods --namespace=${namespace}
        """
    }
}

```

---

### 3. Integrate Shared Library in Jenkins
#### **3.1 Configure Jenkins for Shared Libraries**
1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Configure System**.
2. Find the **Global Pipeline Libraries** section.
3. Add your shared library:
   - **Name**: shared-library
   - **Default version**: main
   - **Retrieval method**: Modern SCM → GitHub → Repository URL

![image](https://github.com/user-attachments/assets/8f6683e1-5b8e-4f78-87ff-2a9b7333a8c2)


#### **3.2 Use the Shared Library in a Pipeline**
Update your Jenkinsfile to load the shared library and use its functions:

**Example Jenkinsfile**

```groovy

```

---

Jenkins will:
1. Use the shared library for all pipeline tasks.
2. Deploy to the correct namespace based on the branch name.

---

## Summary
By implementing Jenkins shared libraries, you can:
- Centralize and reuse common pipeline logic.
- Simplify Jenkinsfiles by abstracting repetitive tasks.
- Improve maintainability and scalability of your CI/CD pipelines.

---

## Commands Recap
- **Apply Shared Library**: Configure in Jenkins settings.
- **Run Pipeline**: Jenkins automatically uses the shared library functions.
- **Deploy**: Verify Kubernetes namespaces using:

```bash
kubectl get pods -n <namespace>
kubectl get deployments -n <namespace>
```

---

## Conclusion
Jenkins shared libraries enable modular, reusable, and maintainable CI/CD pipelines. This task demonstrated the creation and integration of shared libraries for common tasks such as Docker image management and Kubernetes deployment.

---

## Next Steps
1. Enhance shared libraries by adding error handling and logging.
2. Integrate notifications (e.g., Slack) for build and deployment statuses.
3. Use shared libraries across multiple projects for scalability.

