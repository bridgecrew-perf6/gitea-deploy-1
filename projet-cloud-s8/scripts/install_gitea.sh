#!/bin/bash

# install gitear server
# Gitea https://gitea.io/

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE_GITEA="/vagrant/logs/install_gitea.log"
LOG_FILE="/vagrant/logs/install_dependencies.log"
GITEA_URL="https://dl.gitea.io/gitea/1.16.1/gitea-1.16.1-linux-amd64"
DEBIAN_FRONTEND="noninteractive"
GITEA_SERVICE="files/gitea.service"

echo "=> [1]: Installing required packages..."
sudo apt-get install $APT_OPT \
  git \
  zip \
  >> $LOG_FILE 2>&1
echo "END - Installing required packages..."

echo "=> [2]: Installing gitea..."

# Imports Gitea files
wget -O /usr/local/bin/gitea $GITEA_URL >> $LOG_FILE_GITEA 2>&1
chmod +x /usr/local/bin/gitea >> $LOG_FILE_GITEA 2>&1

# Creates Git user
adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git >> $LOG_FILE_GITEA 2>&1

mkdir -pv /var/lib/gitea/{custom,data,log} >> $LOG_FILE_GITEA 2>&1
chown -Rv git:git /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 750 /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
mkdir -v /etc/gitea >> $LOG_FILE_GITEA 2>&1

# Permissions
chown -Rv root:git /etc/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 770 /etc/gitea >> $LOG_FILE_GITEA 2>&1

# Adds Gitea service file and starting the service
cp /vagrant/$GITEA_SERVICE /etc/systemd/system/ >> $LOG_FILE_GITEA 2>&1
systemctl start gitea >> $LOG_FILE_GITEA 2>&1
systemctl enable gitea >> $LOG_FILE_GITEA 2>&1
echo "END - Installing gitea"

echo "=> [3]: Enabling cron backup"
crontab -u git /vagrant/files/cron_backup >> $LOG_FILE_GITEA 2>&1
echo "END - Backup enabled"

# automation of app.ini --> complicated because the file is created @init and not before







