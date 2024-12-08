# Task 5: Ansible Dynamic Inventories

## Objective
Set up Ansible dynamic inventories to automatically discover and manage infrastructure. Use an Ansible Galaxy role to install Apache on the managed nodes.

---

## Steps to Complete the Task

### 1. **Install the Required Dependencies**

Before setting up the dynamic inventory, ensure that you have the necessary tools installed, such as `boto3` for AWS integration (if you're using AWS) and `python3` for managing dynamic inventories.

#### 1. **Install boto3 (for AWS)**
If you're using AWS for infrastructure, you'll need `boto3` to enable dynamic inventory management.

   ```bash
   sudo apt install python3
   pip install boto3
```
#### 2. **Install Ansible**
Ensure Ansible is installed on the control node:

   ```bash
   sudo apt update
   sudo apt install ansible -y

```
#### 3. **Configure Dynamic Inventory**
Set Up Dynamic Inventory Script To use dynamic inventories, configure a script to interact with your cloud provider or infrastructure management system. For AWS, Ansible provides a dynamic inventory script.
   ```bash
   mkdir aws_ec2.yml
   vim aws_ec2.yml
```
add this Configuration and customize  
```bash
---
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
filters:
  "tag:Name": ivolve
  instance-state-name: running  
keyed_groups:
  - key: tags.Name
    prefix: tag
```
#### 4. **Configure AWS Credentials**
Ensure your AWS credentials are set up properly. You can either configure them using environment variables or through an AWS credentials file.

   ```bash
   aws configure
```
and add your AWS credentials

#### 5. **add ansible.cfg file**
to add ansible Configuration file 

```bash
[defaults]
inventory = ./aws_ec2.yml
remote_user = ansibleusr    
```
#### 6. **Test the Dynamic Inventory**
You can test your dynamic inventory script by running:

   ```bash
ansible-inventory -i aws_ec2.yml --list 
```

#### 7. **Use Ansible Galaxy Role to Install Apache**
Install the Apache Role from Ansible Galaxy
You can use Ansible Galaxy to install roles that automate common tasks. For this task, we'll use the geerlingguy.apache role, which installs Apache.
```bash 
ansible-galaxy install geerlingguy.apache 
```
#### 8. **Create the Playbook**
You can test your dynamic inventory script by running:
```bash
vim playbook.yml
 
```
```bash
---
- name: Install Apache
  hosts: all
  become: yes
  roles:
    - geerlingguy.apache
```
#### 9. **Run the Playbook with Dynamic Inventory**
Run the playbook using the dynamic inventory script:

```bash
ansible-playbook playbook.yaml -i aws_ec2.yml 
```
Ansible will automatically discover the web servers and install Apache on them using the role from Ansible Galaxy.

#### 10. **Verify Apache Installation**
Once the playbook runs successfully, verify that Apache is installed and running on the target servers.

```bash
sudo systemctl status apache2
```
Test in a browser: Open a web browser and navigate to the IP address of the managed nodes. You should see the default Apache web page.


