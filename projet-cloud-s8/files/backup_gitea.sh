#!/bin/bash

# backup of the gitea files and service
# we will use the command line method given in Gitea's documentation
# https://docs.gitea.io/en-us/backup-and-restore/

REMOTE_SERVER_IP="192.168.4.87"
LOG_FILE_BACKUP="/home/git/logs/backup.log"

# Switch to git user
su git

./gitea dump -c /etc/gitea/app.ini >> $LOG_FILE_BACKUP 2>&1

# Sends the backed up zip to remote server
scp gitea-dump-*.zip etudiant@$REMOTE_SERVER_IP:/Data/etudiant/Backup/

