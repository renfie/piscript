#!/bin/bash

botID=xxx
chatID=xxx

test -f /usr/bin/speedtest || sudo apt install iperf3 -y

#speedtest --secure > /ramdisk/temp.txt
#sed '1,6d' /ramdisk/temp.txt > /ramdisk/temp2.txt
#sed '2d' /ramdisk/temp2.txt > /ramdisk/temp.txt

iperf3 -c speedtest.wtnet.de -p 5202 -R -t 10 -i 1 > /ramdisk/temp.txt
sed -n '18,18p' /ramdisk/temp.txt > /ramdisk/temp2.txt

speedtest=$(cat /ramdisk/temp2.txt)
speedtest="Speedtest-Home%0A"+$speedtest

#Ergebnis per Telegram
#curl -X POST "https://api.telegram.org/$botID/sendMessage" -d "chat_id=$chatID&text=$speedtest"
curl -s --data "text=$speedtest" --data "chat_id=$chatID" 'https://api.telegram.org/bot'$botID'/sendMessage' > /dev/null

#garbage collection
rm /ramdisk/temp.txt
rm /ramdisk/temp2.txt
