#!/bin/bash

## install web server with php

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE_GITEA="/vagrant/logs/install_gitea.log"
LOG_FILE_GO="/vagrant/logs/install_go.log"
LOG_FILE_NODE="/vagrant/logs/install_node.log"
LOG_FILE="/vagrant/logs/install_dependencies.log"
NODE_URL="https://deb.nodesource.com/setup_17.x"
GITEA_REPO_URL="https://github.com/go-gitea/gitea.git"
GITEA_SERVICE_URL="https://raw.githubusercontent.com/go-gitea/gitea/main/contrib/systemd/gitea.service"
GO_URL="https://go.dev/dl/go1.17.6.linux-amd64.tar.gz"
DEBIAN_FRONTEND="noninteractive"

echo "=> [1]: Installing required packages..."
sudo apt-get install $APT_OPT \
  git \
  curl \
  make \
  >> $LOG_FILE 2>&1


echo "=> [2]: Installing Go language support"
cd ~
wget $GO_URL >> $LOG_FILE_GO 2>&1
sudo tar -C /usr/local/ -xvf go1.17.6.linux-amd64.tar.gz >> $LOG_FILE_GO 2>&1
sudo echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "END - configuring go language"


echo "=> [3]: Installing NodeJS"
cd
curl -fsSL $NODE_URL | sudo -E bash -
sudo apt-get install -y nodejs >> $LOG_FILE_NODE 2>&1
echo "END - install nodejs" 

echo "=> [4]: Installing Gitea"
git clone $GITEA_REPO_URL >> $LOG_FILE_GITEA 2>&1
cd gitea
sudo apt install -y go-bindata >> $LOG_FILE_GO 2>&1
TAGS="bindata" make build >> $LOG_FILE_GITEA 2>&1
echo "END - install gitea"
echo "=> [5]: Launching Gitea webservice"
cd
curl -O $GITEA_SERVICE_URL >> $LOG_FILE_GITEA 2>&1
sudo cp gitea.service /etc/systemd/system/ >> $LOG_FILE_GITEA 2>&1




