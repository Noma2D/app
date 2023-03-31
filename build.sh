#!/bin/bash

export $(cat  variables | xargs)

sudo apt update
sudo apt install sshpass
sudo apt install ansible
sudo sed "s/#\ StrictHostKeyChecking/StrictHostKeyChecking\ No/" /etc/ssh/ssh_config
sudo sed "s/#\ UserKnownHostsFile/UserKnownHostsFile\ \/dev\/null/" /etc/ssh/ssh_config

sudo cp /etc/hosts hosts

echo "$INSTANCE_1 $HOSTNAME_1
$INSTANCE_2 $HOSTNAME_2
$INSTANCE_3 $HOSTNAME_3" | sudo tee -a "hosts"

echo "[swarm_master]
$INSTANCE_1 ansible_user=$SSH_USERNAME ansible_ssh_password=$SSH_PASSWORD
[swarm_nodes]
$INSTANCE_2 ansible_user=$SSH_USERNAME ansible_ssh_password=$SSH_PASSWORD
$INSTANCE_3 ansible_user=$SSH_USERNAME ansible_ssh_password=$SSH_PASSWORD" | sudo tee -a "inventory.ini"

sudo ansible-playbook -i inventory.ini playbook.yml --extravars "INSTANCE_1=$INSTANCE_1 INSTANCE_2=$INSTANCE_2 INSTANCE_3=$INSTANCE_3 COMPETITOR=$COMPETITOR_ID HOSTNAME_1=$HOSTNAME_1 HOSTNAME_2=$HOSTNAME_2 HOSTNAME_3=$HOSTNAME_3"