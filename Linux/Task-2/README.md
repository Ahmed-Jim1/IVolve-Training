# Lab 2: Shell Scripting Basics 1

## Objective
The objective of this task is to schedule a shell script to run daily at 5:00 PM that automatically checks disk space usage for the root file system and sends an email alert if the disk usage exceeds a specified threshold (10%).

---

## Steps to Complete the Task

### 1. **Configure Your Machine to Send Emails Using msmtp and Mailutils with Gmail**
Install msmtp and mailutils
 ```bash
   sudo apt update
   sudo apt install msmtp mailutils
```
### 2. **Create an msmtp Configuration File**
Create a configuration file for msmtp to specify the Gmail SMTP server and your Gmail credentials. The configuration file is typically stored at ~/.msmtprc
 ```bash
   nano ~/.msmtprc
```
Add the following configuration:
 ```paintext
account gmail
host smtp.gmail.com
port 587
from your_email@gmail.com
auth on
user your_email@gmail.com
password your_gmail_password
tls on
tls_starttls on
logfile ~/.msmtp.log
account default : gmail
```

### 3. **Set Proper Permissions for the Configuration File**
 ```bash
   sudo chmod 600 ~/msmtprc
```
### 4. **Test msmtp**
 ```bash
   echo "This is a test email from msmtp." | msmtp recipient_email@example.com
```
### 4. **Make the Script Executable**
 ```bash
   sudo chmod +x ./getUsage.sh
```
### 5. **Schedule the Script Using cron**
 To run the script daily at 5:00 PM, use cron. First, open the crontab editor:
 ```bash
   sudo crontab -e
```
Then, add the following line to schedule the script
 ```bash
   0 17 * * * /usr/local/bin/check_disk_space.sh
```
Check your email at 5:00AM 
