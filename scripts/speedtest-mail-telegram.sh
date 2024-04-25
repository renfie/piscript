#!/bin/bash

botID=XXX
chatID=XXX
mailAddress=bla@bla.com
path=/home/pi/scripts

test -f /usr/bin/speedtest || sudo apt install speedtest-cli -y

speedtest --secure > $path/temp.txt
sed '1,6d' $path/temp.txt > $path/temp2.txt
sed '2d' $path/temp2.txt > $path/temp.txt

speedtest=$(cat $path/temp.txt)

#Ergebnis per Mail
echo -e "Subject:Speedtest\n\n $speedtest \n\n" | sudo sendmail $mailAddress

#Ergebnis per Telegram
curl -X POST "https://api.telegram.org/$botID/sendMessage" -d "chat_id=$chatID&text=$speedtest"

#garbage collection
rm $path/temp.txt
rm $path/temp2.txt
