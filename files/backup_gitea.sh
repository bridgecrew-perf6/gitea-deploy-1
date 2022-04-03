#!/bin/bash

# backup of the gitea files and service
# we will use the command line method given in Gitea's documentation
# https://docs.gitea.io/en-us/backup-and-restore/

REMOTE_SERVER_LOCATION="etudiant@192.168.0.42:/Data/etudiant/Backup-gitea/"
LOG_FILE_BACKUP="/home/git/logs/backup.log"
SSH_CRED="/home/git/.ssh/giteakey"
DATE="`date +"%H%M%d%m%Y"`"

# Switch to git user
su git
cd
gitea dump -w /home/git/dump/  -c /etc/gitea/app.ini -f /home/git/backup-gitea/$DATE.zip >> $LOG_FILE_BACKUP 2>&1

# Sends the backed up zip to remote server
scp -o "StrictHostKeyChecking=no" -i $SSH_CRED $DATE.zip $REMOTE_SERVER_LOCATION

