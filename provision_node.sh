# Install cloud-init
apt-get update
apt-get install -y cloud-init

# Setup cloud-init for boot
systemctl enable cloud-init
systemctl restart cloud-init

# Setup for cloud-init to run
rm -rf /var/lib/cloud/instance /var/lib/cloud/sem/* \
  /var/lib/cloud/seed/nocloud-net/user-data /var/lib/cloud/instances/*

cp cloud-init-user-data /user-data

# Run cloud init
cloud-init -f /user-data init
cloud-init -f /user-data modules
cloud-init -f /user-data modules -m final