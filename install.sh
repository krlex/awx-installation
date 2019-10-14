#!/usr/bin/env bash

TOOLS="awx/tools/"
INSTALLER="awx/installer/"

echo "Upgrade and installation common"
sudo yum -y install vim net-tools git yum-utils device-mapper-persistent-data

echo "Set up stable repo for docker"
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

echo "Enable the nightly repo"
sudo yum-config-manager --enable docker-ce-nightly
yum -y --enablerepo=rhui-REGION-rhel-server-extras install container-selinux

echo "Installation docker"
sudo yum -y install docker-ce docker-ce-cli containerd.io

echo "Starting docker"
sudo systemctl start docker

echo "Set up python3-pip repo"
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm

echo "Update and install Python3"
sudo yum -y install python3-pip

echo "Install ansible"
pip3 install ansible --user

echo "Set up docker-compse "
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


echo "Git cloning AWX in /root/ from krlex/awx github repo 7.0 version"
git clone https://github.com/krlex/awx

echo "Docker-compose starting ...."
cd $TOOLS
docker-compose up

echo "Ansible configuration and installation"
cd $INSTALLER

ansible-playbook -i inventory install.yml
