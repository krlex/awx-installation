#!/usr/bin/env bash
export HOME="/root"

export TOOLS=~/awx/tools/
export INSTALLER=~/awx/installer/

echo "Upgrade and installation common"
sudo yum -y  update
sudo yum -y  install vim net-tools git yum-utils device-mapper-persistent-data gcc libselinux-python3.x86_64

echo "Git cloning AWX from krlex/awx github repo 14.1 version"
sudo git clone https://github.com/ansible/awx $HOME/awx
#chown -R vagrant vagrant $HOME/awx

echo "Update and install Python3"
sudo yum -y install python3-pip.noarch python36 python36-devel python36-libs python36-tools

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
ln /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo pip install docker ansible

echo "Docker-compose starting ...."
cd $TOOLS
/usr/local/bin/docker-compose up -d

echo "Ansible configuration and installation"
ansible-playbook -i ~/awx/installer/inventory ~/awx/installer/install.yml

echo "URL address"
URL=$(sudo ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
