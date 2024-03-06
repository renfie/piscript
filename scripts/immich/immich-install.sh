#!/bin/bash
############################################
#####Immich Install                        #
#####         © renfie 2024                #
############################################

echo "benötigte Ordner im Homeverzeichnis anlegen"
cd ~
mkdir $PWD/docker-files
mkdir $PWD/docker-files/immich

cd $PWD/docker-files/immich
rm -rf *
mkdir -p redis db upload micro cache

echo "hole passende docker-compose.yml"
wget -O docker-compose.yml https://raw.githubusercontent.com/renfie/piscript/main/scripts/immich.yml

echo "hole env-Datei"
wget -O .env https://raw.githubusercontent.com/renfie/piscript/main/scripts/.env

echo "starte immich-Container"
docker compose up -d
