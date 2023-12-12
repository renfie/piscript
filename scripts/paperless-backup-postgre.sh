#!/bin/bash

#Export:
#docker exec paperless-db bash -c "pg_dumpall -U paperless > /var/lib/postgresql/data/backup/Backup.sql"

#Import:
#docker exec paperless-db bash -c "psql -U paperless < /var/lib/postgresql/data/backup/Backup.sql"


#SMB-Credentials
SMB_USER="..."
SMB_PASS="..."

# SMB-Netzwerklaufwerk
SMB_DIR="//yourIP/Backup/paperless"


# Datum Praefix vor den Dateinamen YYYYMMDD
DATE_PREFIX=$(date +%Y-%m-%d)
# Mountingpoint vom SMB Netzwerklaufwerkes
MOUNT_DIR="/root/backup"
# Das PAPERLESS Verzeichnis
PAPERLESS_DIR="/root/docker-files/paperless/export"
# Name und Ablageort des Datenbank Dumps
THE_DUMP="/root/docker-files/paperless/db/backup/*"


# -- Bitte ab hier nichts mehr manuell anpassen --

# SMB Laufwerk mounten
#mount -t cifs -o credentials=$SMB_CRED_FILE $SMB_DIR $MOUNT_DIR
mount -t cifs -o vers=1.0,user=$SMB_USER,password=$SMB_PASS,rw,file_mode=0777,dir_mode=0777 $SMB_DIR $MOUNT_DIR

# SQL-Dump erstellen
docker exec paperless-db bash -c "pg_dumpall -U paperless > /var/lib/postgresql/data/backup/Backup.sql"

# Paperless-NGX Backup erstellen
docker exec -it paperless document_exporter ../export

# Alles in das Zielverzeichnis mit tar sichern
tar -cvpf "$MOUNT_DIR/$DATE_PREFIX-paperless.tar" $PAPERLESS_DIR $THE_DUMP


# Garbagge Collection
rm $THE_DUMP &
rm -rf $PAPERLESS_DIR/* &
umount $MOUNT_DIR
