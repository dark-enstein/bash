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

sudo apt update -y

sudo apt upgrade -y

echo "Installing other helper tools such as curl, wget, and apt-transport-https"

sudo apt install -y curl wget apt-transport-https

echo "Installing Minikube"

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo cp minikube-linux-amd64 /usr/local/bin/minikube

sudo chmod +x /usr/local/bin/minikube

echo "Minikube Version"

minikube version

echo "Downloading and installing Kubectl"

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

kubectl version -o yaml

echo "Setting current user to have administrative permissions to run docker commands"

sudo usermod -aG docker ubuntu && newgrp docker

echo "Cloning Dick Chesterwood Istio Fleetmans' course"

git clone https://github.com/DickChesterwood/istio-fleetman.git

sleep 5

echo "Start Minikube"

minikube start --driver=docker --memory 4096

echo "Changed working directory to Course files"

cd istio-fleetman/_course_files

echo "Install Nginx"

sudo apt update

sudo apt install -y nginx


