# Task 1: AWS Security 

## Objective
Create an AWS account, set up billing alarms and budgets, configure IAM groups, users, and permissions, and verify access restrictions.

---

## Steps

### **1. Create an AWS Account**
- **Action:** Sign up for a new AWS account at [AWS Sign-Up](https://aws.amazon.com/signup/).
- **Screenshot Suggestion:**  
  ![AWS Account Creation Screenshot](images/aws-account-signup.png)

---
### **2. Set Up AWS Budgets**
1. **Navigate to AWS Budgets:**  
   - Go to **AWS Management Console** → **Billing Dashboard** → **Budgets**.

2. **Create a Budget:**  
   - **Budget Type:** Cost Budget  
   - **Name:** e.g., `ivolve-budget-account1`  
   - **Period:** Monthly  
   - **Amount:** Set your desired threshold (e.g., `$10`).  

3. **Configure Notifications:**  
   - **Thresholds:**  
     - 80% of the budget: Send a notification.  
     - 100% of the budget: Send a critical notification.  
   - **Notification Channels:**  
     - Add your email address or use an existing SNS topic.  

4. **Review and Create:**  
   - Verify settings and click **Create Budget**.
---
### **3. Set a Billing Alarm**
1. **Navigate to CloudWatch:**  
   - Go to **AWS Management Console** → **CloudWatch**.

2. **Create Billing Alarm:**  
   - **Steps:**  
     - **Select Alarms** → **Create Alarm**.  
     - Choose **Billing** → **Total Estimated Charges**.  
     - Set a threshold (e.g., `$10`).  
     - Set up email notifications.  

- **Screenshot Suggestions:**  
  ![Billing Alarm Configuration](images/billing-alarm-config.png)  
  ![CloudWatch Dashboard with Alarm](images/cloudwatch-alarm-dashboard.png)

---

### **3. Set Up AWS Budgets**
1. **Navigate to AWS Budgets:**  
   - Go to **AWS Management Console** → **Billing Dashboard** → **Budgets**.

2. **Create a Budget:**  
   - **Budget Type:** Cost Budget  
   - **Name:** e.g., `ivolve-budget-account1`  
   - **Period:** Monthly  
   - **Amount:** Set your desired threshold (e.g., `$10`).  

3. **Configure Notifications:**  
   - **Thresholds:**  
     - 80% of the budget: Send a notification.  
     - 100% of the budget: Send a critical notification.  
   - **Notification Channels:**  
     - Add your email address or use an existing SNS topic.  

4. **Review and Create:**  
   - Verify settings and click **Create Budget**.

- **Screenshot Suggestions:**  
  ![AWS Budgets Dashboard](images/aws-budgets-dashboard.png)  
  ![Budget Configuration Screen](images/budget-config.png)  
  ![Budget Notification Setup](images/budget-notification-setup.png)

---

### **4. Create IAM Groups**
1. **Navigate to IAM Dashboard:**  
   - Go to **AWS Console** → **IAM** → **Groups**.

2. **Create Groups:**
   - **`admin-group`:** Attach **AdministratorAccess** policy.  
   - **`developer-group`:** Attach **AmazonEC2ReadOnlyAccess** policy.  

- **Screenshot Suggestions:**  
  ![IAM Groups Dashboard](images/iam-groups-dashboard.png)  
  ![Permissions Policies for Groups](images/iam-group-policies.png)

---

### **5. Create IAM Users**
1. **Create `admin-1` User (Console Access Only):**
   - Access Type: Console access only.  
   - Add to Group: `admin-group`.  
   - Enable MFA: Use a virtual MFA app.  

2. **Create `admin-2-prog` User (CLI Access Only):**
   - Access Type: Programmatic access (AWS Access Key ID and Secret Access Key).  
   - Add to Group: `admin-group`.  

3. **Create `dev-user` (Console and Programmatic Access):**
   - Access Type: Both console and programmatic access.  
   - Add to Group: `developer-group`.  

- **Screenshot Suggestions:**  
  ![User Creation Screen](images/iam-user-creation.png)  
  ![MFA Setup for admin-1](images/admin-mfa-setup.png)

---

### **6. Configure AWS CLI for `admin-2-prog` and `dev-user`**
1. **Install AWS CLI:** Follow instructions at [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).  

2. **Configure AWS CLI:**  
   ```bash
   aws configure
``
### **7. List Users and Groups Using AWS CLI`**

1. **Run this Command:**  
   ```bash
   aws iam list-users
``
## 8. Verify Access Restrictions for dev-user

### **Access EC2 Console**
1. **Log in as dev-user:**  
   - Use the credentials for `dev-user` to log into the AWS Management Console.
   - Navigate to the **EC2 Dashboard**.

2. **Verify Read-Only Access:**
   - Ensure that `dev-user` can view EC2 instances but cannot make any changes or modifications.

---

### **Attempt to Access S3**
1. **Log in as dev-user:**  
   - Use the credentials for `dev-user` to log into the AWS Management Console again.
   - Navigate to the **S3 Dashboard**.

2. **Verify Access Denied Error:**
   - `dev-user` should see an **Access Denied** message when attempting to access any S3 resources, confirming the restricted permissions.

---

## Screenshot Suggestions

- **EC2 Read-Only Access:**
  ![EC2 Read-Only Access](images/dev-user-ec2-readonly.png)

- **Access Denied for S3:**
  ![S3 Access Denied](images/dev-user-s3-access-denied.png)
## 8. Verify Access Restrictions for dev-user

### **Access EC2 Console**
1. **Log in as dev-user:**  
   - Use the credentials for `dev-user` to log into the AWS Management Console.
   - Navigate to the **EC2 Dashboard**.

2. **Verify Read-Only Access:**
   - Ensure that `dev-user` can view EC2 instances but cannot make any changes or modifications.

---

### **Attempt to Access S3**
1. **Log in as dev-user:**  
   - Use the credentials for `dev-user` to log into the AWS Management Console again.
   - Navigate to the **S3 Dashboard**.

2. **Verify Access Denied Error:**
   - `dev-user` should see an **Access Denied** message when attempting to access any S3 resources, confirming the restricted permissions.

---

## Screenshot Suggestions

- **EC2 Read-Only Access:**
  ![EC2 Read-Only Access](images/dev-user-ec2-readonly.png)

- **Access Denied for S3:**
  ![S3 Access Denied](images/dev-user-s3-access-denied.png)
