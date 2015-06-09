#!/bin/sh
#add by Joey



#LinkStatus
#LinkSSID
#signal
#tx_bitrate

if test $( pgrep -f "hostapd /etc/hostapd.conf /etc/hostapd1.conf -D" | wc -l ) -eq 1
then
	StatusCode=2
elif test $( pgrep -f hostapd | wc -l ) -eq 1
then
	StatusCode=1
else
	StatusCode=0
fi

if [ ${StatusCode} -eq 2 ]
then
	SSID=$(cat /etc/hostapd.conf |grep ssid |head -n 1 |cut -d = -f 2)
	beacon_int=$(cat /etc/hostapd.conf |grep beacon_int |cut -d = -f 2)
	channel1=$(cat /etc/hostapd.conf |grep channel |cut -d = -f 2)
	channel2=$(cat /etc/hostapd1.conf |grep channel |cut -d = -f 2)

	grep ht_capab /etc/hostapd.conf 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]
	then
		HT40_enable=1
	else
		HT40_enable=0
	fi

	max_num_sta=$(cat /etc/hostapd.conf |grep max_num_sta |cut -d = -f 2)
	max_num_sta=`expr $max_num_sta \* 2 - 10`
elif [ ${StatusCode} -eq 1 ]
then
	SSID=$(cat /etc/hostapd.conf |grep ssid |head -n 1 |cut -d = -f 2)
	beacon_int=$(cat /etc/hostapd.conf |grep beacon_int |cut -d = -f 2)
	channel1=$(cat /etc/hostapd.conf |grep channel |cut -d = -f 2)

	grep ht_capab /etc/hostapd.conf 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]
	then
		HT40_enable=1
	else
		HT40_enable=0
	fi

	max_num_sta=$(cat /etc/hostapd.conf |grep max_num_sta |cut -d = -f 2)
fi


iw wlan0 link |grep "Not connected" 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	LinkStatus=0
else
	LinkStatus=1
fi

if [ ${LinkStatus} -eq 1 ]
then
	LinkSSID=$(iw wlan0 link |grep SSID |cut -d : -f 2) 
	LinkSSID=$(echo ${LinkSSID} |sed 's/^ //g')
	signal=$(iw wlan0 link |grep signal |cut -d : -f 2)
	signal=$(echo ${signal} |sed 's/^ //g')
	tx_bitrate=$(iw wlan0 link |grep "tx bitrate" |cut -d : -f 2)
	tx_bitrate=$(echo ${tx_bitrate} |sed 's/^ //g')
fi

if [ ${StatusCode} -eq 2 ]
then
	echo "AP=${StatusCode}&SSID=${SSID}&beacon_int=${beacon_int}&channel=${channel1},${channel2}&HT40_enable=${HT40_enable}&max_num_sta=${max_num_sta}&LinkStatus=${LinkStatus}&LinkSSID=${LinkSSID}&signal=${signal}&tx_bitrate=${tx_bitrate}"
else
	echo "AP=${StatusCode}&SSID=${SSID}&beacon_int=${beacon_int}&channel=${channel1}&HT40_enable=${HT40_enable}&max_num_sta=${max_num_sta}&LinkStatus=${LinkStatus}&LinkSSID=${LinkSSID}&signal=${signal}&tx_bitrate=${tx_bitrate}"
fi
