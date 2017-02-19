#!/bin/sh

# Edit theset varaibles for your setup
DECAPOD_PATH=/vagrant/decapod
DECAPOD_API_ENDPOINT=http:/10.10.10.10:9999
DECAPOD_API_TOKEN=26758c32-3421-4f3d-9603-e4b5337e7ecc
DECAPOD_VERSION_TAG=v0.1.2

# Clone decapod if it isn't already'
if [ ! -d "/vagrant/decapod" ]; then
    git clone --recurse-submodules https://github.com/Mirantis/ceph-lcm.git decapod
fi

# Move into the decapod directory
cd decapod

# Checkout a specific version
git checkout $DECAPOD_VERSION_TAG && git submodule update --init --recursive

# Don't make any changes below
cd $DECAPOD_PATH

# Install some prereqs
sudo apt-get update
sudo apt-get install -y cloud-init python-pip make \
    python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev

pip install setuptools

# Generate public key based on known private key
ssh-keygen -y -f ansible_ssh_keyfile.pem > ~/ansible_ssh_keyfile.pem.pub
chmod 0600 ~/ansible_ssh_keyfile.pem.pub

# Build the decapod cli image
if ! type "shrimp" > /dev/null; then
  make build_eggs
  pip install output/eggs/shrimplib*.whl output/eggs/shrimp_cli*.whl
fi

# Setup cloud-init for boot
sudo systemctl enable cloud-init
sudo systemctl restart cloud-init

# Get the cloud-init user data for OS deployment
shrimp -u $DECAPOD_API_ENDPOINT cloud-config \
  $DECAPOD_API_TOKEN ~/ansible_ssh_keyfile.pem.pub > ~/user-data

# Setup for cloud-init to run
sudo rm -rf /var/lib/cloud/instance /var/lib/cloud/sem/* \
  /var/lib/cloud/seed/nocloud-net/user-data /var/lib/cloud/instances/*

# Run cloud init
sudo cloud-init -f ~/user-data init
sudo cloud-init -f ~/user-data modules
sudo cloud-init -f ~/user-data modules -m final