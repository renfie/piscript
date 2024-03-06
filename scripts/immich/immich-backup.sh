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

# Paperless-NGX Backup erstellen
#docker exec -it Paperless document_exporter ../export
docker exec  immich_postgres pg_dumpall -c -U postgres | gzip > "$MOUNT_DIR/$DATE_PREFIX_immich.sql.gz"

# Zielverzeichnis prüfen, Stopzeit festhalten
echo "...Backup beendet (Stopzeit: $(date +%T))" >> $THE_LOG
ls -lh $MOUNT_DIR >> $THE_LOG

# Garbagge Collection
#rm $THE_LOG $THE_DUMP &
find $MOUNT_DIR -name "*.gz" -daystart -mtime +14 -delete
