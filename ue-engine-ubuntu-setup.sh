#! /bin/bash

echo "Updating Ubuntu Repositories"

sudo apt-get update -y

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
    
echo "Downloading and installing Docker"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

apt-cache madison docker-ce

sudo systemctl status docker

sudo apt-get install docker-compose -y

sudo apt update -y

sudo apt upgrade -y

sudo usermod -aG docker $USER

# Configure docker start-on-build
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Install python and ue4-cli
sudo apt-get install python3 python3-dev python3-pip
sudo pip3 install ue4-docker
sudo ue4-docker setup
