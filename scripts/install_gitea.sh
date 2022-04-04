#!/bin/bash

# install gitear server
# Gitea https://gitea.io/

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE_GITEA="/vagrant/logs/install_gitea.log"
LOG_FILE="/vagrant/logs/install_dependencies.log"
GITEA_URL="https://dl.gitea.io/gitea/1.16.1/gitea-1.16.1-linux-amd64"
DEBIAN_FRONTEND="noninteractive"
GITEA_SERVICE="data/gitea.service"
APP_INI="data/default_ini"
GITEA_SSH="data/giteakey"

echo "=> [1]: Installing required packages..."
apt-get install $APT_OPT \
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
passwd -d git
mkdir -p /home/git/.ssh && chmod 700 /home/git/.ssh && chown git:git /home/git/.ssh >> $LOG_FILE_GITEA 2>&1
if [ ! -f /vagrant/$GITEA_SSH ]; then
  sh /vagrant/files/gitea_ssh.sh >> $LOG_FILE_GITEA 2>&1
fi
cp /vagrant/$GITEA_SSH /home/git/.ssh/ && chmod 600 /home/git/.ssh/giteakey && chown git:git /home/git/.ssh/giteakey >> $LOG_FILE_GITEA 2>&1
mkdir -pv /var/lib/gitea/{custom,data,log} >> $LOG_FILE_GITEA 2>&1
chown -Rv git:git /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 750 /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
mkdir -v /etc/gitea >> $LOG_FILE_GITEA 2>&1

# Permissions
rm /etc/gitea/app.ini >> $LOG_FILE_GITEA 2>&1
cp /vagrant/$APP_INI /etc/gitea/app.ini >> $LOG_FILE_GITEA 2>&1
chown -Rv root:git /etc/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 770 /etc/gitea >> $LOG_FILE_GITEA 2>&1

# Adds Gitea service file and starting the service
cp /vagrant/$GITEA_SERVICE /etc/systemd/system/ >> $LOG_FILE_GITEA 2>&1
systemctl start gitea >> $LOG_FILE_GITEA 2>&1
systemctl enable gitea >> $LOG_FILE_GITEA 2>&1
echo "END - Installing gitea"

echo "=> [3]: Enabling cron backup"
crontab -u vagrant /vagrant/files/cron_backup >> $LOG_FILE_GITEA 2>&1
mkdir /home/git/backup-gitea /home/git/dump /home/git/logs >> $LOG_FILE_GITEA 2>&1
chown -R git:git /home/git/backup-gitea/ /home/git/dump/ /home/git/logs/ >> $LOG_FILE_GITEA 2>&1

echo "END - Backup enabled"






