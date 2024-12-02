#!/bin/bash

# Set the threshold percentage
THRESHOLD=10

# Get the current disk usage percentage for the root filesystem
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Check if the disk usage exceeds the threshold
if [ $USAGE -ge $THRESHOLD ]; then
  # Email settings
  EMAIL="ahmedjim970@gmail.com"
  SUBJECT="Disk Usage Warning: Root Filesystem"
  MESSAGE="Warning: The disk usage for the root filesystem has exceeded $THRESHOLD%. Current usage is at $USAGE%."

  # You can also use mail if msmtp is configured:
   echo "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"
fi

