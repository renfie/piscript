#!/bin/bash

botID=xxx
chatID=-xxx

test -f /usr/bin/speedtest || sudo apt install speedtest-cli -y

speedtest --secure > /ramdisk/temp.txt
sed '1,6d' /ramdisk/temp.txt > /ramdisk/temp2.txt
sed '2d' /ramdisk/temp2.txt > /ramdisk/temp.txt

speedtest=$(cat /ramdisk/temp.txt)
speedtest="Speedtest-Home%0A"+$speedtest

#Ergebnis per Telegram
curl -s --data "text=$speedtest" --data "chat_id=$chatID" 'https://api.telegram.org/bot'$botID'/sendMessage' > /dev/null

#garbage collection
rm /ramdisk/temp.txt
rm /ramdisk/temp2.txt
