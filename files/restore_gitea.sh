#!/bin/bash

# restore of the gitea backup if created with its given ID
# we will use the command line method given in Gitea's documentation
# https://docs.gitea.io/en-us/backup-and-restore/

# Backup location
REMOTE_SERVER_IP="192.168.4.87"
# ID is the value of the server backup to be restored
ID=""
REMOTE_BACKUP="vagrant@$REMOTE_SERVER_IP:/Data/etudiant/Backup/gitea-$ID.zip"
# DB credentials
USER="git"
PASS="secret"
DATABASE="gitea"

if [-f "$REMOTE_BACKUP"]; then
    # Collects the backup from the remote server
    scp $REMOTE_BACKUP /vagrant/files

    unzip gitea-dump-$ID.zip
    cd gitea-dump-$ID

    mv data/conf/app.ini /etc/gitea/conf/app.ini
    mv data/* /var/lib/gitea/data/
    mv log/* /var/lib/gitea/log/
    mv repos/* /home/git/

    chown -R git:git /etc/gitea/conf/app.ini /var/lib/gitea

    mysql --default-character-set=utf8mb4 -u$USER -p$PASS $DATABASE <gitea-db.sql

    service gitea restart
fi
