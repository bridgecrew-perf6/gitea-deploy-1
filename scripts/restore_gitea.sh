#!/bin/bash

# restore of the gitea backup if created with its given ID
# we will use the command line method given in Gitea's documentation
# https://docs.gitea.io/en-us/backup-and-restore/

# Backup location
REMOTE_SERVER_IP="192.168.4.87"
# ID is the value of the server backup to be restored
ID=""
REMOTE_BACKUP="etudiant@$REMOTE_SERVER_IP:/Data/etudiant/Backup-gitea/$ID.zip"
# DB credentials
USER="git"
PASS="secret"
DATABASE="gitea"

if [-f "$REMOTE_BACKUP"]; then
    # Collects the backup from the remote server
    su git
    scp -i /home/git/.ssh/giteakey $REMOTE_BACKUP /home/git/backup-gitea/

    unzip $ID.zip

    mv app.ini /etc/gitea/conf/app.ini
    mv data/* /var/lib/gitea/data/
    mv log/* /var/lib/gitea/log/
    mv repos/* /var/lib/gitea/gitea-repositories

    chown -R git:git /etc/gitea/conf/app.ini /var/lib/gitea

    mysql --default-character-set=utf8mb4 -u$USER -p$PASS $DATABASE <gitea-db.sql

    service gitea restart
fi
