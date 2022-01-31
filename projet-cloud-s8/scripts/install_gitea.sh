#!/bin/bash

## install web server with php

IP=$(hostname -I | awk '{print $2}')

APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_gitea.log"
DEBIAN_FRONTEND="noninteractive"

echo "START - install web Server - "$IP

echo "=> [1]: Installing required packages..."
apt-get install $APT_OPT \
  git \
  curl \
  >> $LOG_FILE 2>&1


echo "=> [2]: Installing Go language support"
cd ~
curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
sha256sum go1.16.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
sudo echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "END - configuring go language"


echo "=> [3]: Installing NodeJS"
cd
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "END - install nodejs"

echo "=> [4]: Installing Gitea"
git clone https://github.com/go-gitea/gitea.git
cd gitea
TAGS="bindata" make build
TAGS="bindata sqlite sqlite_unlock_notify" make build
echo "END - install gitea"
echo "=> [5]: Launching Gitea webservice"
./gitea web




