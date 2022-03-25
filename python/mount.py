#!/usr/bin/env python

import os,time,datetime
i=0
response=1
while response != 0:
	i+=1
	response = os.system("ping -c 1 " + "192.168.2.56")
	time.sleep (1)
	print ("iteration " + str(i))

success = 1
while success != 0:
	success = os.system ("sudo mount -t cifs -o user=admin,password=xxx,rw,file_mode=0777,dir_mode=0777 //192.168.2.56/freigabe/ /home/pi/freigabe")
	if success == True:
		break;
	time.sleep(1)

print("NAS connected")
