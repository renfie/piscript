#!/bin/bash
#Ausgaben prüfen
#set -x
clear
SMB_USER="username"
SMB_PASS="password"
SMB_DIR="//ip-adress/Backup/pi"
MOUNT_DIR="/home/pi/mnt"

#mounten
mounten (){
  sudo mount -t cifs -o vers=1.0,username=${SMB_USER},password=${SMB_PASS},rw,file_mode=0777,dir_mode=0777 ${SMB_DIR} ${MOUNT_DIR}
}
unmount (){
  sudo umount $MOUNT_DIR
}
backup (){
  mounten
  sudo raspiBackup
  unmount
}

host=`hostname`
mount="/home/pi/mnt/${host}/"
vts=$(date +'%Y-%m-%d')

cd ${mount}
mount2=$(ls -rt1 | tail -1)
cd $mount2

img=$(ls *.img -rt1 | tail -1)
image=${mount}${mount2}"/"$img
imagepath=${mount}${mount2}"/"

pishrink () {
  mounten
  sudo pishrink.sh ${image}
  unmount
}

all (){
  echo "führe alles aus"
  backup
  pishrink
}
back (){
  echo "führe Backup aus"
  backup
}
shrink (){
  echo "jetzt shrinken"
  pishrink
}


if [ "$1" = "all" ]; then
  all
elif [ "$1" = "back" ]; then
  back
elif [ "$1" = "shrink" ]; then
  shrink
else
  echo "all, backup or shrink Parameter"
fi
