#!/bin/sh
uptime=$(cat /proc/uptime | awk '// { printf "%dT %02d:%02d", $1/86400, $1/3600%24, $1/60%60 }')
{
echo From: xxx@gmail.com
echo To: xxx@gmail.com
echo Subject: Uptime
echo
echo $uptime
} | sudo sendmail  xxx@gmail.com
