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
curl -fsSL https://raw.githubusercontent.com/renfie/piscript/main/scripts/immich.yml -o docker-compose.yml

echo "hole env-Datei"
curl -fsSL https://raw.githubusercontent.com/renfie/piscript/main/scripts/immich.env -o immich.env

echo "starte immich-Container"
docker compose up -d
