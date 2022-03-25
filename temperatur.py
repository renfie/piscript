#!/usr/bin/env python
 
# Temperaturwert ist als Zeichenkette in der Datei tempData
# gespeichert und wird mit einer Nachkommastelle als
# Zeichenkette angezeigt
# https://www.dgebhardt.de/raspi-projects/projects/fan_control.html
# while endless=0; do echo `date +%T` Uhr: `vcgencmd measure_temp`; sleep 15; done
# watch -n1 vcgencmd measure_clock arm
# watch -n1 vcgencmd measure_temp
 
import time
import os
 
tempData = "/sys/class/thermal/thermal_zone0/temp"
 
while True:
    os.system('clear')
    print("")
    print("Aktuelle CPU-Temperatur im 15s Intervall:")
    print("")
    print("********************************")
    print("")
    print(time.strftime("%d.%m.%Y %H:%M:%S"+ " Uhr: "))
    f = open(tempData, "r")
    a = f.readline(2)
    b = f.readline(1)
    f.close
    temp = a + "." + b + " Grad Celsius"
    print temp
    print("")
    print("********************************")
    time.sleep (15)