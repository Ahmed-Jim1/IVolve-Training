# Task 5: Ansible Dynamic Inventories

## Objective
Set up Ansible dynamic inventories to automatically discover and manage infrastructure. Use an Ansible Galaxy role to install Apache on the managed nodes.

---

## Steps to Complete the Task

### 1. **Install the Required Dependencies**

Before setting up the dynamic inventory, ensure that you have the necessary tools installed, such as `boto3` for AWS integration (if you're using AWS) and `python3` for managing dynamic inventories.

#### a. **Install boto3 (for AWS)**
If you're using AWS for infrastructure, you'll need `boto3` to enable dynamic inventory management.

   ```bash
   pip install boto3
```
