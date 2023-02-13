#!/bin/bash
#Ausgaben prüfen
#set -x
clear

SMB_CRED="/home/pi/scripts/.cifs" #username=User password=Pass
SMB_DIR="//192.168.150.8/Backup/pi"
MOUNT_DIR="/home/pi/mnt"

#sudo mount -t cifs -o vers=1.0,username=${SMB_USER},password=${SMB_PASS},rw,file_mode=0777,dir_mode=0777 ${SMB_DIR} ${MOUNT_DIR}

sudo mount -t cifs -o vers=1.0,user,credentials=${SMB_CRED},rw,file_mode=0777,dir_mode=0777 ${SMB_DIR} ${MOUNT_DIR}


#sudo umount $MOUNT_DIR
