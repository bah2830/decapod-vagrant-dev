#!/bin/sh

# Edit theset varaibles for your setup
DECAPOD_API_ENDPOINT=http://10.10.10.10:9999
DECAPOD_API_TOKEN=26758c32-3421-4f3d-9603-e4b5337e7ecc

# Clone decapod if it isn't already'
if [ ! -d "decapod" ]; then
    git clone --recurse-submodules https://github.com/Mirantis/ceph-lcm.git decapod
fi

# Move into the decapod directory
cd decapod

# Install some prereqs
sudo apt-get update
sudo apt-get install -y python-pip make python-dev libffi-dev \
  libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev

pip install setuptools

# Generate public key based on known private key
chmod 0600 containerization/files/devconfigs/ansible_ssh_keyfile.pem
ssh-keygen -y -f containerization/files/devconfigs/ansible_ssh_keyfile.pem > ~/ansible_ssh_keyfile.pem.pub
chmod 0600 ~/ansible_ssh_keyfile.pem.pub

# Build the decapod cli image
if ! type "decapod" > /dev/null; then
  make build_eggs
  pip install output/eggs/decapodlib*.whl output/eggs/decapod_cli*.whl
fi

# Get the cloud-init user data for OS deployment
echo "Generating cloud-init-user-data.new"
rm -f cloud-init-user-data.new
decapod -u $DECAPOD_API_ENDPOINT cloud-config \
  $DECAPOD_API_TOKEN ~/ansible_ssh_keyfile.pem.pub > ./cloud-init-user-data.new

# Remove some bad requests from user-data
echo "Editing cloud-init-user-data.new"
sed -i '/metadata_ip = get_response/,+3d' ./cloud-init-user-data.new

cp -f cloud-init-user-data.new cloud-init-user-data
rm -f cloud-init-user-data.new