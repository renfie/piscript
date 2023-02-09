#!/bin/bash
#Ausgaben prüfen
#set -x
clear

SMB_USER="..."
SMB_PASS="..."
SMB_DIR="//192.168.150.223/zv/EDV/Backup"
MOUNT_DIR="/home/pi/mnt"

sudo mount -t cifs -o vers=1.0,username=${SMB_USER},password=${SMB_PASS},rw,file_mode=0777,dir_mode=0777 ${SMB_DIR} ${MOUNT_DIR}

host=`hostname`
mount="/home/pi/mnt/${host}/"
vts=$(date +'%Y-%m-%d')

cd ${mount}
mount2=$(ls -rt1 | tail -1)

cd $mount2

img=$(ls *.img -rt1 | tail -1)

image=${mount}${mount2}"/"$img
imagepath=${mount}${mount2}"/"


makeall

sudo umount ${MOUNT_DIR}

raspibackup () {
   sudo raspiBackup
}

pishrink () {
   pishrink.sh ${image}
}

makeall (){
  raspibackup
  pishrink
}
