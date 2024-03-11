#!/bin/bash

# Datum Praefix vor den Dateinamen YYYYMMDD
DATE_PREFIX=$(date +%Y-%m-%d)
# Mountingpoint vom SMB Netzwerklaufwerkes
MOUNT_DIR="/volume1/Eltern/Pi/Backup/immich"
# Das PAPERLESS Verzeichnis
THE_LOG="/volume1/Eltern/Pi/Backup/immich/$DATE_PREFIX-backuplog.txt"

# -- Bitte ab hier nichts mehr manuell anpassen --

# Erstellen der Statusdatei und Hinterlegung der Startzeit
echo "Beginne Backup (Startzeit: $(date +%T))..." > $THE_LOG

# Backup erstellen
docker exec  immich_postgres pg_dumpall -c -U postgres | gzip > "$MOUNT_DIR/$DATE_PREFIX-immich.sql.gz"

# Zielverzeichnis prüfen, Stopzeit festhalten
echo "...Backup beendet (Stopzeit: $(date +%T))" >> $THE_LOG
ls -lh $MOUNT_DIR >> $THE_LOG

# Garbagge Collection
#rm $THE_LOG $THE_DUMP &
find $MOUNT_DIR -name "*.gz" -daystart -mtime +14 -delete

#Wiederherstellung der Datenbank
#https://immich.app/docs/administration/backup-and-restore
#Beachten Sie, dass für eine ordnungsgemäße Wiederherstellung der Datenbank eine vollständige Neuinstallation erforderlich ist 
#(dh der Immich-Server wurde seit der Erstellung der Docker-Container nie ausgeführt). 
#Wenn die Immich-App ausgeführt wurde, können bei der Datenbankwiederherstellung Postgres-Konflikte auftreten (Beziehung bereits vorhanden, verletzte Fremdschlüsseleinschränkungen, mehrere Primärschlüssel usw.).

#gunzip < "/path/to/backup/dump.sql.gz" | docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup
