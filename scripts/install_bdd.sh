#!/bin/bash

## install server mariadb

IP=$(hostname -I | awk '{print $2}')
APT_OPT="-o Dpkg::Progress-Fancy="0" -q -y"
LOG_FILE="/vagrant/logs/install_bdd.log"
DEBIAN_FRONTEND="noninteractive"

#SQL file for database
DBFILE="data/initial_gitea_db.sql"

echo "START - install MariaDB - "$IP

echo "=> [1]: Install required packages ..."
apt-get install $APT_OPT \
	mariadb-server \
	mariadb-client \
  >> $LOG_FILE 2>&1
echo "END - Installed required packages"

echo "=> [2]: Database init and mysql conf"

  sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
  mysql < /vagrant/$DBFILE \
  >> $LOG_FILE 2>&1
  service mysql restart

echo "END - installed database"
