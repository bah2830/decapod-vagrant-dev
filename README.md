# Decapod Vagrant Development
Quick and simple way of spinning up vagrant hosts with decapod containers for testing ceph deployments

### What's Included
Vagrant will provision 4 vms. One vm for decapod itself and three others to be used as ceph nodes for testing.


## Requirements
### Using Vagrant
 - virtualbox
 - vagrant 

### Without Vagrant
 - ubuntu 16.04 LTS
 - docker 
 - docker-compose
 

## Deploy Decapod
### With Vagrant
 - `vagrant up`
   - deployment will take up to an hour to build the decapod containers
 - `vagrant ssh decapod`
 - `cd /vagrant`
 - `./build.sh`

### Without Vagrant  
This will deploy only decapod on the current host using docker. It will bypass all vagrant requirements.
 - `./deploy.sh`

## Adding Server To Cluster
 - Log into base setup of any node 
 - `./add_server.sh` 
   - If needed edit the varaibles at the top of the script for your setup 

## Login
Login at https://10.10.10.10:10000
 - username: root
 - password: root