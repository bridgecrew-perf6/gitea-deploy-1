
# Gitea Server (Cloud S8)

This project aims at creating a Gitea server, with automated Backup, and scripts for restoring previous versions in case of a recovery need.


## Prerequisites

This project uses Vagrant for virtual machine provisioning.
The default hypervisor used here is VirtualBox.

You are free to use a different Hypervisor and modify the Vagrantfile accordingly.

That being said, you need Vagrant and a Hypervisor (VirtualBox here)

For  the backup to work properly you need to have generated a ssh key pair (call it giteakey for ease of use).
Add the public key to the destination machine's authorized_keys file, and add your private key to this directory (here it would be /files/giteakey)

This will allow you to send the backup files over to the machine that will serve as the backup holder.
You can modify the scripts' variables to match your needs (remote server ip, backup location, etc ...)

Now, specific to our use case for this project, there are a couple of things to do and/or modify for the network configuration to work properly.

By default, the default gateway is configured to the NAT interface in the Vagrantfile.
You can change the IPs in the Vagrantfile if needed.
On the same topic, we, at our lab have issues with iptables;
it can happen that we need to run the following command:
iptables -F
which flushes iptables.

The file/cron_backup file contains the cron configuration for the backup script to be called. You can change it if you want as well.



