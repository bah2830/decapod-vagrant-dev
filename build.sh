#!/bin/sh

DECAPOD_VERSION_TAG=v0.1.0

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

# Checkout a specific version
git checkout $DECAPOD_VERSION_TAG && git submodule update --init --recursive

# Build decapod images. make build_containers_dev fails due to out of order container build
make copy_example_keys
make build_container_db_data
make build_container_db
make build_container_api
make build_container_controller
make build_container_cron
make build_container_frontend

# Run containers 
docker-compose up -d