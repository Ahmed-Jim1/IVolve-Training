# Lab 3: Shell Scripting Basics 2

## Objective
Create a shell script to ping every server in the `172.16.17.x` subnet (where `x` is a number between `0` and `255`). If the ping succeeds, display the message "Server 172.16.17.x is up and running". If the ping fails, display the message "Server 172.16.17.x is unreachable".

---

## Steps to Complete the Task

### 1. **Create the Script File**
   First, create a new shell script file. You can name it `ping_servers.sh`:
   ```bash
   vim ping_servers.sh
```
### 2. **Make the Script Executable**
 ```bash
   sudo chmod +x ./ping-servers.sh
```
### 3. **Run the script**
 ```bash
    ./ping-servers.sh
```

