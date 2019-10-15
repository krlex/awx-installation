#!/usr/bin/env bash

HOME="/home/$USER/"
TOOLS="~/$HOME/awx/tools/"
INSTALLER="~/$HOME/awx/installer/"

echo "Upgrade and installation common"
sudo yum -y update
sudo yum -y install vim net-tools git yum-utils device-mapper-persistent-data gcc

echo "Set up stable repo for docker"
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

echo "Enable the nightly repo"
sudo yum-config-manager --enable docker-ce-nightly

echo "Installation docker"
sudo yum -y install docker-ce docker-ce-cli containerd.io

echo "Starting docker"
sudo systemctl start docker

echo "Update and install Python3"
sudo yum -y install python3-pip.noarch python36 python36-devel python36-libs python36-tools

echo "Install ansible"
pip3 install --user ansible docker-compose

#echo "Set up docker-compse "
#sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose


echo "Git cloning AWX from krlex/awx github repo 7.0 version"
git clone https://github.com/krlex/awx

echo "Docker-compose starting ...."
cd $TOOLS
docker-compose up

echo "Ansible configuration and installation"
cd $INSTALLER

ansible-playbook -i inventory install.yml
