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

  # Be nice to the host by only giving each vm half a cpu
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "decapod" do |node|
    node.vm.hostname = "decapod"
    node.vm.network "private_network", ip: "10.10.10.10"

    node.vm.provision "shell", inline: $bootstrapScript
  end

  config.vm.define "ceph1" do |node|
      node.vm.hostname = "ceph1"
      node.vm.network "private_network", ip: "10.10.10.11"
  end

  config.vm.define "ceph2" do |node|
      node.vm.hostname = "ceph2"
      node.vm.network "private_network", ip: "10.10.10.12"
  end

  config.vm.define "ceph3" do |node|
      node.vm.hostname = "ceph3"
      node.vm.network "private_network", ip: "10.10.10.13"
  end
end