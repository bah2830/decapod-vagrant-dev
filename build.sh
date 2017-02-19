#!/bin/sh

# Add nodejs repo if not already installed
if ! type "node" > /dev/null; then
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
fi

# Setup Decapod dependencies
sudo apt-get update && sudo apt-get install -y python-pip nodejs git make
pip install setuptools

# Clone the decapod repo if not already
if [ ! -d "decapod" ]; then
    git clone --recurse-submodules https://github.com/Mirantis/ceph-lcm.git decapod
fi

# Move into the decapod directory
cd decapod

# Change the base image 
sed -i 's/FROM docker-prod-virtual.docker.mirantis.net/ubuntu:xenial/FROM ubuntu:xenial/g' containerization/backend-base.dockerfile
sed -i 's/FROM docker-prod-virtual.docker.mirantis.net/nginx:stable/FROM nginx:stable/g' containerization/frontend.dockerfile

# Build decapod images.
make build_containers_dev

# Run containers 
docker-compose up -d