#!/bin/bash

## install server postgres

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_bdd.log"
DEBIAN_FRONTEND="noninteractive"

#Fichier sql à injecter (présent dans un sous répertoire)
#DBFILE="files/creation_bdd_visionote.sql"

echo "START - install MariaDB - "$IP

echo "=> [1]: Install required packages ..."
DEBIAN_FRONTEND=noninteractive
apt-get install $APT_OPT \
	mariadb-server \
	mariadb-client \
   >> $LOG_FILE 2>&1

echo "=> [3]: Database remote access configuration"
  sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
  sudo service mysql restart
echo "=> [4]: Configuration de BDD"

  mysql < /vagrant/$DBFILE \
  >> $LOG_FILE 2>&1

echo "END - install MariaDB"
