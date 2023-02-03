#!/bin/bash
############################################
#####Docker, Docker Compose, Phyton,       #
#####pip-package installieren und Portainer#
#####unter Port 9443 anlegen.              #
#####         © renfie 2023                #
############################################

echo "benötigte Ordner anlegen im Homeverzeichnis anlegen"
cd ~
mkdir $PWD/docker-files

echo "Update und Upgrade"
apt install sudo -y
sudo apt update && apt full-upgrade -y

echo "curl installieren"
sudo apt install curl -y

echo "hole get-docker"
curl -fsSL https://get.Docker.com -o get-Docker.sh
chmod +x get-Docker.sh

echo "Docker installieren"
sh get-Docker.sh
rm get-Docker.sh
echo "notwendige Rechte anpassen"
usermod -aG docker $USER
#newgrp docker

echo "Phyton installieren"
sudo apt install -y python3 python3-pip -y

echo "docker-compose installieren"
sudo pip3 install docker-compose

echo "PortainerDate Volume erstellen"
docker volume create portainer_data

echo "Portainer starten"
docker run -d -p 8000:8000 -p 9443:9443 --name portainer  -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:latest
