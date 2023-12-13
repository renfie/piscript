#!/bin/bash

#sudo mount -t cifs -o vers=1.0,user=USER,password=PASS,rw,file_mode=0777,dir_mode=0777 //192.168.150.223/zv /home/pi/backup

#container sql backup
#docker exec SQL_CONTAINER /usr/bin/mysqldump -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB > NEXTCLOUD_DB.sql

#container sql restore
#cat NEXTCLOUD_DB.sql | docker exec -i SQL_CONTAINER /usr/bin/mysql -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB

#SMB-Credentials
SMB_USER="..."
SMB_PASS="...."

# SMB-Netzwerklaufwerk
SMB_DIR="//192.168.150.8/Backup/paperless"

# Datum Praefix vor den Dateinamen YYYYMMDD
DATE_PREFIX=$(date +%Y-%m-%d)
# Mountingpoint vom SMB Netzwerklaufwerkes
MOUNT_DIR="/root/backup"
# Das PAPERLESS Verzeichnis
PAPERLESS_DIR="/root/docker-files/paperless/export"
# Name und Ablageort des Datenbank Dumps
THE_DUMP="/root/docker-files/paperless/db/backup/$DATE_PREFIX-paperless-DB.sql"

#SQL-Credentials
SQL_USER="..."
SQL_PASS="..."
SQL_DB="paperless"

PAPERLESS_Container="paperless"
MariaDB_Container="maria-db"

# -- Bitte ab hier nichts mehr manuell anpassen --


# SMB Laufwerk mounten
#mount -t cifs -o credentials=$SMB_CRED_FILE $SMB_DIR $MOUNT_DIR
mount -t cifs -o vers=1.0,user=$SMB_USER,password=$SMB_PASS,rw,file_mode=0777,dir_mode=0777 $SMB_DIR $MOUNT_DIR

# Erstellen mysql Dump
docker exec $MariaDB_Container mysqldump -u $SQL_USER --password=$SQL_PASS $SQL_DB > $THE_DUMP

# Paperless-NGX Backup erstellen
docker exec -it $PAPERLESS_Container document_exporter ../export

# Alles in das Zielverzeichnis mit tar sichern
tar -cvpf "$MOUNT_DIR/$DATE_PREFIX-paperless.tar" $PAPERLESS_DIR $THE_DUMP


# Garbagge Collection
rm $THE_DUMP &
rm -rf $PAPERLESS_DIR/* &
umount $MOUNT_DIR
