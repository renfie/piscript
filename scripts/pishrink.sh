#!/bin/sh

#################################################################################################################
#################################################################################################################
# PiShrink ist ein kleines Script, welches den nicht genutzt Speicher im Backup löscht.                         #
# Ist also z.B. bei deiner 64GB Speicherkarte nur rund 2GB belegt, werden die restlichen 62GB gelöscht.         #
# Am Ende haben wir ein 2GB großes Image, welches wir auch z.B. auf eine 8GB SD-Karte wiederherstellen können.  #
#################################################################################################################
#################################################################################################################


wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
sudo chmod +x pishrink.sh
sudo mv pishrink.sh /usr/local/bin
cd /pfad/zu/deinem/image/
sudo pishrink.sh Image_Name.img
