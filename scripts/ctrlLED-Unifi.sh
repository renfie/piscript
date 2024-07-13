#!/bin/bash

#cron:
#* 22 * * * /home/pi/scripts/ctrlLED-Unifi.sh 192.178.3.2 off #Wohnzimmer
#* 08 * * * /home/pi/scripts/ctrlLED-Unifi.sh 192.178.3.2 on #Wohnzimmer

#* 08 * * * /home/pi/scripts/ctrlLED-Unifi.sh 192.178.3.3 off #Werkstatt
#* 21 * * * /home/pi/scripts/ctrlLED-Unifi.sh 192.178.3.3 on #Werkstatt

IP="$1"

turnOFF(){
    ssh admin@$IP -f "sed -i 's/mgmt.led_enabled=true/mgmt.led_enabled=false/g' /var/etc/persistent/cfg/mgmt; syswrapper.sh reload"
}

turnON(){
    ssh admin@$IP -f "sed -i 's/mgmt.led_enabled=false/mgmt.led_enabled=true/g' /var/etc/persistent/cfg/mgmt; syswrapper.sh reload"
}


case "$2" in
  on)
    turnON
    ;;
  off)
    turnOFF
    ;;
esac
