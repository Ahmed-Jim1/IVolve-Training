# Task 1: User and Group Management

## Objective
Create a new group named `ivolve` and a new user assigned to this group with a secure password. Configure the user’s permissions to allow installing Nginx with elevated privileges using the `sudo` tool, without requiring a password.

---

## Steps to Complete the Task

### 1. **Create a New Group**
   ```bash
   sudo groupadd ivolve 
  ```
### 2. **Create a New User and Assign to the Group**
   ```bash
   sudo useradd -m -G ivolve -s /bin/bash ivolveuser
  ```
### 3. ** Set a Secure Password for the User**
   ```bash
   ssudo passwd ivolveuser
  ```
### 4. **Grant sudo Privileges to the User**
Open the sudoers file
   ```bash
   sudo visudo
  ```
Add the following line at the end of the file
 ```bash
   ivolveuser ALL=(ALL) NOPASSWD: /usr/bin/apt-get install nginx
  ```
### 5. **Verification Steps**
Switch to the New User
   ```bash
   sudo su - ivolveuser
  ```

Install Nginx Using sudo
   ```bash
   sudo su - ivolveuser
  ```
The installation should proceed without prompting for a password.

Check if Nginx is Installed
```bash
   nginx -v
  ```
