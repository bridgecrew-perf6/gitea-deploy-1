#!/bin/bash

# install gitear server
# Gitea https://gitea.io/

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE_GITEA="/vagrant/logs/install_gitea.log"
LOG_FILE="/vagrant/logs/install_dependencies.log"
GITEA_URL="https://api.github.com/repos/go-gitea/gitea/releases/latest"
DEBIAN_FRONTEND="noninteractive"
GITEA_SERVICE="data/gitea.service"
APP_INI="data/default_ini"
GITEA_SSH="data/giteakey"

echo "=> [1]: Installing required packages..."
apt-get update $APT_OPT \
  >> $LOG_FILE 2>&1
apt-get install $APT_OPT \
  git \
  zip \
  curl \
  >> $LOG_FILE 2>&1
echo "END - Installed required packages..."

echo "=> [2]: Installing gitea..."

# Create Git User

sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

mkdir -p /home/git/.ssh && chmod 700 /home/git/.ssh && chown git:git /home/git/.ssh >> $LOG_FILE_GITEA 2>&1
if [ ! -f /vagrant/$GITEA_SSH ]; then
  sh /vagrant/files/gitea_ssh.sh >> $LOG_FILE_GITEA 2>&1
fi
cp /vagrant/$GITEA_SSH /home/git/.ssh/ && chmod 600 /home/git/.ssh/giteakey && chown git:git /home/git/.ssh/giteakey >> $LOG_FILE_GITEA 2>&1


# Imports Gitea files

curl -s  $GITEA_URL |grep browser_download_url  |  cut -d '"' -f 4  | grep '\linux-amd64$' | wget -i - >> $LOG_FILE_GITEA 2>&1
chmod +x gitea-*-linux-amd64 >> $LOG_FILE_GITEA 2>&1
sudo mv gitea-*-linux-amd64 /usr/local/bin/gitea >> $LOG_FILE_GITEA 2>&1

# Create Gitea service

sudo mkdir -p /etc/gitea /var/lib/gitea/{custom,data,indexers,public,log} >> $LOG_FILE_GITEA 2>&1
sudo chown git:git /var/lib/gitea/{data,indexers,log} >> $LOG_FILE_GITEA 2>&1
sudo chmod 750 /var/lib/gitea/{data,indexers,log} >> $LOG_FILE_GITEA 2>&1
sudo chown root:git /etc/gitea >> $LOG_FILE_GITEA 2>&1
sudo chmod 770 /etc/gitea >> $LOG_FILE_GITEA 2>&1

cp /vagrant/$GITEA_SERVICE /etc/systemd/system/gitea.service >> $LOG_FILE_GITEA 2>&1

sudo systemctl daemon-reload
sudo systemctl enable --now gitea

sudo systemctl stop gitea
sudo rm /etc/gitea/app.ini
su cp /vagrant/$APP_INI /etc/gitea/app.ini

sudo systemctl daemon-reload
sudo systemctl enable --now gitea

echo "END - Installing gitea"

echo "=> [3]: Enabling cron backup"
crontab -u vagrant /vagrant/files/cron_backup >> $LOG_FILE_GITEA 2>&1
mkdir /home/git/backup-gitea /home/git/dump /home/git/logs >> $LOG_FILE_GITEA 2>&1
chown -R git:git /home/git/backup-gitea/ /home/git/dump/ /home/git/logs/ >> $LOG_FILE_GITEA 2>&1

echo "END - Backup enabled"






