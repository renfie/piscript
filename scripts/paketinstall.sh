
#!/bin/bash
#set -x
clear
paket=$1

pruefung=$(dpkg -l | awk '/'${paket}'/ {print }'|wc -l)

echo "Prüfung ergab "$pruefung

update (){
  echo "führe Update durch und installiere $paket"
  apt update
  apt install $paket -y
}

pruefer (){
if [ "$pruefung" = "0" ]
then
    echo "$paket ist nicht installiert und wird jetzt installiert"
    #update
else
    echo "$paket ist installiert"
fi
}

if [ -z $1 ]
then
  echo "Bitte Paketnamen eingeben"
  exit 1
else
  pruefer
fi
