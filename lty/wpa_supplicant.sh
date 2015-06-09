#!/bin/sh
#add by Joey for start wpa_supplicant



#echo "SSID is" $1
#echo "key is" $2

USAGE() {
	echo "	error:	must be have 1 or 2 parameter"
	echo "	usage:	wpa_supplicant.sh SSID [key]"
	exit 1
}

create_file() {
	echo "create wpa_supplicant config file"
	
	echo "ctrl_interface=/var/run/wpa_supplicant" >/etc/wpa_supplicant.conf
	echo "update_config=1" >>/etc/wpa_supplicant.conf
	echo "ap_scan=1" >>/etc/wpa_supplicant.conf
	
	if [ $1 -eq 1 ]
	then
		echo "network={" >>/etc/wpa_supplicant.conf
		echo "ssid=\"$2\"" >>/etc/wpa_supplicant.conf
		echo "scan_ssid=1" >>/etc/wpa_supplicant.conf
		echo "key_mgmt=NONE" >>/etc/wpa_supplicant.conf
		echo "}" >>/etc/wpa_supplicant.conf
	else
		wpa_passphrase $2 $3 >>/etc/wpa_supplicant.conf
	fi

}

if [ $# -lt 1 ] ; then 
	USAGE
fi
if [ $# -gt 2 ] ; then 
	USAGE
fi

echo "wpa_supplicant start or restart..."

if [ $# -eq 2 ]
then
	create_file 2 $1 $2
else
	create_file 1 $1
fi

killall wpa_supplicant
wpa_supplicant -Dnl80211 -iwlan0 -c/etc/wpa_supplicant.conf &

echo "wpa_supplicant start or restart successful"
