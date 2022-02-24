#!/bin/bash

## install web server with php

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE_GITEA="/vagrant/logs/install_gitea.log"
LOG_FILE="/vagrant/logs/install_dependencies.log"
GITEA_URL="https://dl.gitea.io/gitea/1.16.1/gitea-1.16.1-linux-amd64"
DEBIAN_FRONTEND="noninteractive"

echo "=> [1]: Installing required packages..."
sudo apt-get install $APT_OPT \
  git \
  >> $LOG_FILE 2>&1
echo "END - Installing required packages..."

echo "=> [2]: Installing gitea..."
wget -O /usr/local/bin/gitea $GITEA_URL >> $LOG_FILE_GITEA 2>&1
chmod +x /usr/local/bin/gitea >> $LOG_FILE_GITEA 2>&1
adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git >> $LOG_FILE_GITEA 2>&1
mkdir -pv /var/lib/gitea/{custom,data,log} >> $LOG_FILE_GITEA 2>&1
chown -Rv git:git /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 750 /var/lib/gitea >> $LOG_FILE_GITEA 2>&1
mkdir -v /etc/gitea >> $LOG_FILE_GITEA 2>&1
chown -Rv root:git /etc/gitea >> $LOG_FILE_GITEA 2>&1
chmod -Rv 770 /etc/gitea >> $LOG_FILE_GITEA 2>&1
touch /etc/systemd/system/gitea.service >> $LOG_FILE_GITEA 2>&1
echo "
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
Requires=mysql.service

[Service]
LimitMEMLOCK=infinity
LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/gitea.service
systemctl start gitea >> $LOG_FILE_GITEA 2>&1
systemctl enable gitea >> $LOG_FILE_GITEA 2>&1

echo "END - Installing gitea"








