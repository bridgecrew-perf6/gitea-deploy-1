#!/bin/bash

# backup of the gitea files and service
# we will use the command line method given in Gitea's documentation
# https://docs.gitea.io/en-us/backup-and-restore/

REMOTE_SERVER_LOCATION="etudiant@192.168.4.87:/Data/etudiant/Backup-gitea/"
LOG_FILE_BACKUP="/home/git/logs/backup.log"

# Switch to git user
su git
cd
gitea dump -w /home/git/dump/  -c /etc/gitea/app.ini -f /home/git/backup-gitea/"`date +"%H%M%d%m%Y"`".zip >> $LOG_FILE_BACKUP 2>&1

# Sends the backed up zip to remote server
scp -i /home/git/.ssh/giteakey gitea-dump-*.zip $REMOTE_SERVER_LOCATION

