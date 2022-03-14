# -*- mode: ruby -*-
# vi: set ft=ruby :


# prerequisite "iptables -F" avant lancement
# pas de regle de filtrage sur la machine hote pouvant bloquer les com
# (del ip route default gateway and change to .50)

Vagrant.configure("2") do |config|
  config.vm.define "srv-gitea" do |machine|
    machine.vm.hostname = "srv-gitea"
    machine.vm.box = "chavinje/fr-bull-64"
    machine.vm.network :public_network, bridge: "eno1", ip: "192.168.4.24", use_dhcp_assigned_default_route: true
    config.vm.provision "shell",
      run: "always",
      inline: "ip route del default via 10.0.2.2 || true"
    config.vm.provision "shell",
      run: "always",
      inline: "ip route add default via 192.168.4.50"
    machine.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--name", "srv-gitea"]
      v.customize ["modifyvm", :id, "--groups", "/S8-cloud"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      # According to Gitea's documentation, 2 cores and 1GB of RAM are necessary
      # If there are any issues, please use 2GB of  RAM instead of 1GB
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
      sleep 3
      service ssh restart
    SHELL
    machine.vm.provision "shell", path: "scripts/install_sys.sh"
    machine.vm.provision "shell", path: "scripts/install_bdd.sh"
    machine.vm.provision "shell", path: "scripts/install_gitea.sh"
  end
end