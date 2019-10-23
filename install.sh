#!/usr/bin/env bash

export HOME="/home/vagrant/"

export TOOLS=~/awx/tools/
export INSTALLER=~/awx/installer/

echo "Upgrade and installation common"
sudo yum -y  update
sudo yum -y  install vim net-tools git yum-utils device-mapper-persistent-data gcc

echo "Git cloning AWX from krlex/awx github repo 7.0 version"
sudo -u vagrant git clone https://github.com/krlex/awx $HOME/awx

echo "Update and install Python3"
sudo yum -y install python3-pip.noarch python36 python36-devel python36-libs python36-tools

echo "Install ansible"
pip3 install docker-compose --user

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

echo "Setup python-pip"
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"

echo "Update and install Python"
sudo python get-pip.py

echo "Install ansible"
sudo pip3 install docker-compose
sudo pip install docker ansible

echo "Docker-compose starting ...."
cd $TOOLS
sudo -u  vagrant /usr/local/bin/docker-compose up

echo "Ansible configuration and installation"
ansible-playbook -i ~/awx/installer/inventory ~/awx/installer/install.yml
