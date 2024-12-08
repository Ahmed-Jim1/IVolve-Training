# Task 4: Ansible Roles for Application Deployment
# Ansible Project: Application Deployment Using Roles

## Overview
This project uses **Ansible Roles** to automate the installation of:
1. **Docker**
2. **Jenkins**
3. **OpenShift CLI (`oc`)**

The roles are organized following Ansible best practices, making the playbook modular, reusable, and easy to manage.

---

## Project Structure

The directory structure of this project is as follows:

![structure](./images/test.png)

## How to Use This Project

Step 1: Define Inventory
Create an inventory file to define the target hosts:

```ini
[hosts]
192.168.19.132
192.168.19.133
18.209.70.116
```

Step 2: Define ansible.cfg file 
Create an ansible.cfg file to define the configration:

```ini
[defaults]
inventory = ./inventory 
remote_user = ansibleusr 
ask_pass = false 

[privilege_escalation]
become = true 
become_method = sudo 
become_user = root 
become_ask_pass = false

```
Step 2: Run the Playbook

```bash
ansible-playbook palybook.yaml -i inventory 
```
Step 3: Verify Installations

- Docker: Check with docker --version
- Jenkins: Access via http://<server-ip>:8080
- OpenShift CLI: Verify with oc version
