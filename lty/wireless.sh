#!/bin/sh
#add by Joey

iw dev wlan0 interface add wlan0_ap0 type managed 4addr on
h1=0x$(ifconfig wlan0 | grep wlan0 | awk '{print $5}' | awk -F: '{print $1 $2 $3 $4 $5 $6}')
ip link set dev wlan0_ap0 address $(printf "%012X\n" $((h1+1)) | sed 's/[0-9A-F][0-9A-F]\B/&:/g')
ip link set dev wlan0 up
ip link set dev wlan0_ap0 up
iw dev wlan1 interface add wlan1_ap0 type managed 4addr on
h2=0x$(ifconfig wlan1 | grep wlan1 | awk '{print $5}' | awk -F: '{print $1 $2 $3 $4 $5 $6}')
ip link set dev wlan1_ap0 address $(printf "%012X\n" $((h2+1)) | sed 's/[0-9A-F][0-9A-F]\B/&:/g')
ip link set dev wlan1 up
ip link set dev wlan1_ap0 up

#iw dev wlan0 set 4addr on
#iw dev wlan0_ap0 set 4addr on
#iw dev wlan1 set 4addr on
#iw dev wlan1_ap0 set 4addr on

brctl addbr br0
brctl addif br0 wlan0_ap0
brctl addif br0 wlan1_ap0

ip link set dev br0 up
ip address add local 192.168.100.1/24 brd + dev br0


#udhcpc -iwlan0&

