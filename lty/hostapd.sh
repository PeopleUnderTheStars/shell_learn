#!/bin/sh
#add by Joey for start hostapd



#echo "SSID is" $1
#echo "beacon_int is" $2
#echo "HT40 is" $3
#echo "max_num_sta is" $4

USAGE() {
	echo "	error:	must be have 4 parameter"
	echo "	usage:	hostapd.sh SSID beacon_int HT40 max_num_sta"
	exit 1
}

start_hostapd() {
	killall hostapd
	if [ $1 -eq 2 ]
	then
		hostapd /etc/hostapd.conf /etc/hostapd1.conf -D &
	else
		hostapd /etc/hostapd.conf &
	fi
}

create_file() {
	echo "create config file"
	
	if [ $5 -eq 1 ]
	then
		echo "interface=wlan0_ap0" >/etc/hostapd.conf
		echo "bridge=br0" >>/etc/hostapd.conf
		echo "driver=nl80211" >>/etc/hostapd.conf
		echo "ssid=$1" >>/etc/hostapd.conf
		echo "utf8_ssid=1" >>/etc/hostapd.conf
		echo "hw_mode=g" >>/etc/hostapd.conf
		echo "channel=1" >>/etc/hostapd.conf
		echo "dtim_period=1" >>/etc/hostapd.conf
		echo "rts_threshold=1000" >>/etc/hostapd.conf
		echo "fragm_threshold=2346" >>/etc/hostapd.conf
		echo "auth_algs=1" >>/etc/hostapd.conf
		echo "beacon_int=$2" >>/etc/hostapd.conf
		echo "country_code=US" >>/etc/hostapd.conf
		echo "ieee80211n=1" >>/etc/hostapd.conf
		if [ $3 == 1 ]
		then
			echo "ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]" >>/etc/hostapd.conf
		fi
		echo "max_num_sta=$4" >>/etc/hostapd.conf
	else
		max_sta=`expr $4 / 2 + 5`
		
		echo "interface=wlan0_ap0" >/etc/hostapd.conf
		echo "bridge=br0" >>/etc/hostapd.conf
		echo "driver=nl80211" >>/etc/hostapd.conf
		echo "ssid=$1" >>/etc/hostapd.conf
		echo "utf8_ssid=1" >>/etc/hostapd.conf
		echo "hw_mode=g" >>/etc/hostapd.conf
		echo "channel=1" >>/etc/hostapd.conf
		echo "dtim_period=1" >>/etc/hostapd.conf
		echo "rts_threshold=1000" >>/etc/hostapd.conf
		echo "fragm_threshold=2346" >>/etc/hostapd.conf
		echo "auth_algs=1" >>/etc/hostapd.conf
		echo "beacon_int=$2" >>/etc/hostapd.conf
		echo "country_code=US" >>/etc/hostapd.conf
		echo "ieee80211n=1" >>/etc/hostapd.conf
		if [ $3 == 1 ]
		then
			echo "ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]" >>/etc/hostapd.conf
		fi
		echo "max_num_sta=$max_sta" >>/etc/hostapd.conf
		
		echo "interface=wlan1_ap0" >/etc/hostapd1.conf
		echo "bridge=br0" >>/etc/hostapd1.conf
		echo "driver=nl80211" >>/etc/hostapd1.conf
		echo "ssid=$1" >>/etc/hostapd1.conf
		echo "utf8_ssid=1" >>/etc/hostapd1.conf
		echo "hw_mode=g" >>/etc/hostapd1.conf
		echo "channel=7" >>/etc/hostapd1.conf
		echo "dtim_period=1" >>/etc/hostapd1.conf
		echo "rts_threshold=1000" >>/etc/hostapd1.conf
		echo "fragm_threshold=2346" >>/etc/hostapd1.conf
		echo "auth_algs=1" >>/etc/hostapd1.conf
		echo "beacon_int=$2" >>/etc/hostapd1.conf
		echo "country_code=US" >>/etc/hostapd1.conf
		echo "ieee80211n=1" >>/etc/hostapd1.conf
		if [ $3 == 1 ]
		then
			echo "ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]" >>/etc/hostapd1.conf
		fi
		echo "max_num_sta=$max_sta" >>/etc/hostapd1.conf
		echo "ignore_broadcast_ssid=2" >>/etc/hostapd1.conf
	fi
	
	start_hostapd $5
}

if [ $# != 4 ] ; then 
	USAGE
fi 

echo "hostapd start or restart..."

ifconfig wlan1 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]
then
	create_file $1 $2 $3 $4 2
else
	create_file $1 $2 $3 $4 1
fi

echo "hostapd start or restart successful"
