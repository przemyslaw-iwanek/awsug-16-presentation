#!/bin/bash

# Get current timestamp
DATE=`date +%s`

# Generate backup and compress it!
dd if=/dev/urandom of=/dev/stdout bs=1024 count=1024 | gzip -c > /root/backups/backup_${DATE}.gz_temp

# Move temp file to correct one
mv /root/backups/backup_${DATE}.gz_temp /root/backups/backup_${DATE}.gz
