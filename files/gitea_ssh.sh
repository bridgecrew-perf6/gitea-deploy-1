#!/bin/bash

## generates ssh key for 

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/gitea_ssh.log"
DEBIAN_FRONTEND="noninteractive"

echo "START - Generating ssh keypair for git user "

su git
ssh-keygen -f /home/git/.ssh/giteakey -t rsa -N '' >> $LOG_FILE 2>&1   # generates ssh keypair for git user
su root
cp /home/git/.ssh/giteakey /vagrant/data/ >> $LOG_FILE 2>&1

echo "END - Shared git's ssh key "