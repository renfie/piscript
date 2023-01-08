#!/bin/sh
SCRIPTPATH=$(cd `dirname $0` && pwd)
FILE=./docker-compose.yml
if [ $# -eq 0 ]
  then
    echo "You have to input the name of the container, the ip-adress, directory of the new server..."
    exit 1
else
    echo "The name of the container is " $1
    echo "The ip-adress is " $2
    echo "The directory of the new server is " $3
fi
echo "do some update"
#sudo apt update
echo "rsync is installing"
#sudo apt install rsync -y

if [ -f "$FILE" ]; then
    echo "$FILE exists..."
#    sudo mv $FILE $FILE.bak
#   docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/red5d/docker-autocompose $1 > docker-compose.yml
else
    echo "$FILE does not exist. Downloading docker-autocompose and create docker-compose.yml..."
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/red5d/docker-autocompose $1 > docker-compose.yml
fi
echo "copy files..."
sudo rsync -azv --progress $SCRIPTPATH $USER@$2:$3/

echo "connect to new server and take the container online"

ssh -X $USER@$2 -t "cd $SCRIPTPATH && sudo docker-compose up -d"
