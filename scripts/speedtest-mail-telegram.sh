#!/bin/bash

botID=XXX
chatID=XXX

test -f /usr/bin/speedtest || sudo apt install speedtest-cli -y

speedtest --secure > /home/pi/scripts/temp.txt
sed '1,6d' /home/pi/scripts/temp.txt > /home/pi/scripts/temp2.txt
sed '2d' /home/pi/scripts/temp2.txt > /home/pi/scripts/temp.txt

speedtest=$(cat /home/pi/scripts/temp.txt)

#Ergebnis per Mail
echo -e "Subject:Speedtest-Garten\n\n $speedtest \n\n" | sudo sendmail renefieler@gmail.com

#Ergebnis per Telegram
curl -X POST "https://api.telegram.org/$botID/sendMessage" -d "chat_id=$chatID&text=$speedtest"

#garbage collection
rm /home/pi/scripts/temp.txt
rm /home/pi/scripts/temp2.txt
