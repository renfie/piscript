#!/bin/bash
############################################
#####Immich Full-Install                   #
#####         © renfie 2024                #
############################################

echo "benötigte Ordner im Homeverzeichnis anlegen"
cd ~
mkdir $PWD/docker-files
mkdir $PWD/docker-files/immich

cd $PWD/docker-files/immich
mkdir -p redis db upload micro cache

echo "Update und Upgrade"
apt update && apt dist-upgrade -y

echo "hole get-docker"
curl -fsSL https://get.Docker.com -o get-Docker.sh
chmod +x get-Docker.sh

echo "Docker installieren"
./get-Docker.sh
rm get-Docker.sh
echo "notwendige Rechte anpassen"
usermod -aG docker $USER

echo "Portainer starten"
docker run -d -p 8000:8000 -p 9443:9443 --name portainer  --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:latest

echo "hole passende docker-compose.yml"
wget -O docker-compose.yml https://raw.githubusercontent.com/renfie/piscript/main/scripts/immich/immich.yml

echo "hole env-Datei"
wget -O .env https://raw.githubusercontent.com/renfie/piscript/main/scripts/immich/.env

echo "starte immich-Container"
docker compose up -d
