# Lab 2: Ansible Playbooks for install NGINX

## Objective
Write an Ansible playbook to automate the configuration of a web server. The playbook will install and configure Nginx on a web server, ensuring the service is running and enabled to start on boot.

---

## Steps to Complete the Task

#### 1. **Create and add your hosts in the Inventory File**
Create the  Ansible inventory file and add hosts
   ```bash
   sudo mkdir ansible
   cd ansible
   mkdir inventory
   ```
Add the IP address or hostname of the web server(s) under a webservers group:
 ```bash
   vim inventory
   ```
```plain-text
[hosts]
192.168.19.132
192.168.19.133
```
Save and close the file.

### 2. **Prepare ansible.cfg File**


Create the  playbook.yaml
   ```bash
   vim ansibel.cfg
```
Write the Playbook
```plain-text
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

#### 3. **Create playbook File**
Create the  playbook.yaml
   ```bash
   vim playbook.yaml
```
Write the Playbook
```yaml
---
- name: Configure Nginx
  hosts: hosts
  become: yes
  tasks:
    - name: installe nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Start and enable Nginx service
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy a basic HTML page
      copy:
        content: "<h1>Hello ivolve</h1>"
        dest: /var/www/html/index.html

    - name: Allow HTTP through the firewall
      ufw:
        rule: allow
        port: '80'
        proto: tcp

    - name: Ensure firewall is enabled
      ufw:
        state: enabled
```
Here's a breakdown of what each task does:

Install Nginx: This task installs Nginx on the target machine.
Ensure Nginx is running and enabled: This ensures that the Nginx service is running and will start on boot.
Create a custom index.html page: This task creates a simple HTML file that will be served by the Nginx web server.

#### 4. **run the playbook**
Create the  playbook.yaml
   ```bash
   ansible-playbook playbook.yaml -i inventory
```

Verify the Configuration
Once the playbook has run successfully, you can verify the configuration:

a. Check the Web Server
Open a web browser and navigate to the IP address or hostname of your web server. You should see the "Welcome to Nginx!" page with the message "Hello from Ansible!"

b. Verify Nginx Service
On the server, check if Nginx is running and enabled
```bash
sudo systemctl status nginx
```

















