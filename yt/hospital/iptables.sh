#!/bin/sh


while [ "1" = "1" ]
do
	iptables -t nat -nvL WiFiDog_br-lan_AuthServers | head -n 3 | grep 10.10.10.254
	if [ $? -eq 1 ]
	then
		sleep 5
		while [ "1" = "1" ]
		do
                	iptables -t nat -nvL WiFiDog_br-lan_AuthServers | head -n 3 | grep 10.10.10.254
			if [ $? -eq 1 ]
			then
				iptables -t nat -D WiFiDog_br-lan_AuthServers 1
				iptables -t filter -D  WiFiDog_br-lan_AuthServers 1
			else
				break
			fi
		done
	fi
	sleep 1
done
