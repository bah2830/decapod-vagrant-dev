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
 

## Build Decapod From Source
### With Vagrant
 - `vagrant up decapod`
   - deployment will take up to an hour to build the decapod containers
 - `vagrant ssh decapod`
 - `cd /vagrant`
 - `./deploy_decapod.sh`

### Without Vagrant  
This will deploy only decapod on the current host using docker. It will bypass all vagrant requirements.
 - `./deploy_decapod.sh`


## Generating new cloud init data
 - `./generate_cloud_init_data.sh`


## Adding Server To Cluster
 - From host with docker installed `./generate_cloud_init_data.sh`
 - Copy cloud-init-user-data to new node
 - In new node run `./provision_node.sh` 
  



## Login
Login at https://10.10.10.10:10000
 - username: root
 - password: root