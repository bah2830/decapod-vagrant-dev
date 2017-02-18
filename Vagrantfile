# -*- mode: ruby -*-
# vi: set ft=ruby :

$bootstrapScript = <<SCRIPT
# Setup Docker and Docker-compose
if ! type "docker" > /dev/null; then
    curl -sSL https://get.docker.com/ | sh

    # Add vagrant user to 
    usermod -aG docker ubuntu

    # Download docker-compose binary
    curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

service docker restart
SCRIPT

$decapodBuild = <<SCRIPT
cd /vagrant
./build.sh
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provision "shell", inline: $bootstrapScript, preserve_order: true
  config.vm.provision "shell", inline: $decapodBuild, privileged: false, preserve_order: true
end