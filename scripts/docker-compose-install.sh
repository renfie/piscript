#!/bin/bash
############################################
#####Docker und Portainer installieren     #
#####unter Port 9443 anlegen.              #
#####         © renfie 2023                #
############################################

echo "benötigte Ordner anlegen im Homeverzeichnis anlegen"
cd ~
mkdir $PWD/docker-files

echo "Update und Upgrade"
apt install sudo -y
apt update && apt dist-upgrade -y

echo "curl installieren"
apt install curl -y

echo "hole get-docker"
curl -fsSL https://get.Docker.com -o get-Docker.sh
chmod +x get-Docker.sh

echo "Docker installieren"
sh get-Docker.sh
rm get-Docker.sh
echo "notwendige Rechte anpassen"
usermod -aG docker $USER

echo "Portainer starten"
docker run -d -p 8000:8000 -p 9443:9443 --name portainer  --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:latest
