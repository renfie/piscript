#!/bin/bash

#container sql backup
#docker exec SQL_CONTAINER /usr/bin/mysqldump -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB > NEXTCLOUD_DB.sql
#container sql restore
#cat NEXTCLOUD_DB.sql | docker exec -i SQL_CONTAINER /usr/bin/mysql -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB


# Datum Praefix vor den Dateinamen YYYYMMDD
DATE_PREFIX=$(date +%Y-%m-%d)

# Mountingpoint vom SMB Netzwerklaufwerkes
MOUNT_DIR="/volume1/Eltern/Pi/Backup/SQL"

# Das PAPERLESS Verzeichnis
PAPERLESS_DIR="/volume1/docker/paperlessngx/export"

# Name und Ablageort der Statusdatei YYYYMMDD-backuplog.txt
THE_LOG="/volume1/Eltern/Pi/Backup/SQL/$DATE_PREFIX-backuplog.txt"

# Name und Ablageort des Datenbank Dumps
THE_DUMP="/volume1/Eltern/Pi/Backup/SQL/$DATE_PREFIX-paperless-DB.sql"

SQL_USER="..."
SQL_PASS="..."
SQL_DB="paperless"


# -- Bitte ab hier nichts mehr manuell anpassen --

# Erstellen der Statusdatei und Hinterlegung der Startzeit
echo "Beginne Backup (Startzeit: $(date +%T))..." > $THE_LOG

# Erstellen mysql Dump
mysqldump -u $SQL_USER --password=$SQL_PASS $SQL_DB > $THE_DUMP

# Paperless-NGX Backup erstellen
docker exec Paperless document_exporter ../export

# Alles in das Zielverzeichnis mit tar sichern
tar -czvpf "$MOUNT_DIR/$DATE_PREFIX-paperless.tar.gz" $PAPERLESS_DIR $THE_DUMP

# Zielverzeichnis prüfen, Stopzeit festhalten
echo "...Backup beendet (Stopzeit: $(date +%T))" >> $THE_LOG
ls -lh $MOUNT_DIR >> $THE_LOG

# Garbagge Collection
rm $THE_DUMP &
rm -rf $PAPERLESS_DIR/* &

find $MOUNT_DIR -name "*.tar.gz" -daystart -mtime +14 -delete
