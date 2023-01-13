#!/bin/bash

#sudo mount -t cifs -o vers=1.0,user=USER,password=PASS,rw,file_mode=0777,dir_mode=0777 //192.168.150.223/zv /home/pi/backup

#container sql backup
#docker exec SQL_CONTAINER /usr/bin/mysqldump -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB > NEXTCLOUD_DB.sql

#container sql restore
#cat NEXTCLOUD_DB.sql | docker exec -i SQL_CONTAINER /usr/bin/mysql -u SQL_USER --password=SQL_PASS NEXTCLOUD_DB



# Datum Praefix vor den Dateinamen YYYYMMDD
DATE_PREFIX=$(date +%Y%m%d)

#SQL-Parameter
SQL_CONTAINER="mariadb-mariadb-1"
# Der Datenbankname
#NEXTCLOUD_DB="DB"

NEXTCLOUD_CONTAINER="CONTAINER"

#SMB-Credentials
SMB_USER="USER"
SMB_PASS="PASS"

# SMB-Netzwerklaufwerk
SMB_DIR="//192.168.150.223/..."

# Mountingpoint vom SMB Netzwerklaufwerkes
MOUNT_DIR="/home/pi/backup"

# SMB Credentials Datei für die SMB Zugangsdaten
#SMB_CRED_FILE="/root/.smbcredentials"

# Das Nextcloud Verzeichnis
NEXTCLOUD_DIR="/home/pi/docker-files/nextcloud"


# Name und Ablageort der Statusdatei YYYYMMDD-backuplog.txt
THE_LOG="/root/$DATE_PREFIX-backuplog.txt"

# Name und Ablageort des Datenbank Dumps
THE_DUMP="/root/$DATE_PREFIX-cloud-DB.sql"

# Empfänger der Statusdatei
SEND_REP="name@domain.tld"

# Exclude Dateien oder Ordner
EXCLUDE_PATTERN="--exclude='$NEXTCLOUD_DIR/data/updater*' --exclude='$NEXTCLOUD_DIR/data/*.log'"



# -- Bitte ab hier nichts mehr manuell anpassen --

# Erstellen der Statusdatei und Hinterlegung der Startzeit
echo "Beginne Backup (Startzeit: $(date +%T))..." > $THE_LOG

# SMB Laufwerk mounten
#mount -t cifs -o credentials=$SMB_CRED_FILE $SMB_DIR $MOUNT_DIR
mount -t cifs -o vers=1.0,user=$SMB_USER,password=$SMB_PASS,rw,file_mode=0777,dir_mode=0777 $SMB_DIR $MOUNT_DIR

# Wartungsmodus der Nextcluod aktivieren
#sudo -u www-data php $NEXTCLOUD_DIR/occ maintenance:mode --on
sudo docker exec -u www-data $NEXTCLOUD_CONTAINER php occ maintenance:mode --on

# Erstellen mysql Dump
#mysqldump $NEXTCLOUD_DB > $THE_DUMP
sudo docker exec $SQL_CONTAINER /usr/bin/mysqldump -u nextcloud --password=nextcloud nextcloud > $THE_DUMP

# Alles in das Zielverzeichnis mit tar sichern
tar $EXCLUDE_PATTERN -cvpf "$MOUNT_DIR/$DATE_PREFIX-cloud.tar" $NEXTCLOUD_DIR $THE_DUMP

# Wartungsmodus deaktivieren
#sudo -u www-data php $NEXTCLOUD_DIR/occ maintenance:mode --off
sudo docker exec -u www-data $NEXTCLOUD_CONTAINER php occ maintenance:mode --off

# Zielverzeichnis prüfen, Stopzeit festhalten
echo "...Backup beendet (Stopzeit: $(date +%T))" >> $THE_LOG
ls -lh $MOUNT_DIR >> $THE_LOG

# Statusdatei senden
sendmail $SEND_REP < $THE_LOG

# Garbagge Collection
rm $THE_LOG $THE_DUMP &
umount $MOUNT_DIR
