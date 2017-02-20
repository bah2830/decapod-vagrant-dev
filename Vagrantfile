# -*- mode: ruby -*-
# vi: set ft=ruby :

$bootstrapScript = <<SCRIPT
# Setup Docker and Docker-compose
curl -sSL https://get.docker.com/ | sh

# Add vagrant user to 
usermod -aG docker ubuntu

# Download docker-compose binary
curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.define "decapod" do |node|
    node.vm.hostname = "decapod"
    node.vm.network "private_network", ip: "10.10.10.10"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus   = 3
    end

    node.vm.provision "shell", inline: $bootstrapScript
  end

  ["ceph1", "ceph2", "ceph3"].each_with_index do |host, idx|
    config.vm.define "#{host}" do |node|
      node.vm.hostname = "#{host}"
      node.vm.network "private_network", ip: "10.10.10.2#{idx}"

      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        vb.memory = 512
        vb.cpus   = 1
      end
    end
  end
end