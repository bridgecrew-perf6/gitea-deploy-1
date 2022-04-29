#!/bin/bash

LOG_FILE= "/vagrant/logs/install_zabbix_agent.log"
DEBIAN_VERSION="debian11"
DEBIAN_FRONTEND="noninteractive"
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-1+${DEBIAN_VERSION}_all.deb >> $LOG_FILE 2>&1
apt-get update >> $LOG_FILE 2>&1

apt-get -y install zabbix-agent >> $LOG_FILE 2>&1

sed -i 's/Server=127.0.0.1/Server=192.168.56.0\/24,192.168.0.40\/29/g' /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent >> $LOG_FILE 2>&1
