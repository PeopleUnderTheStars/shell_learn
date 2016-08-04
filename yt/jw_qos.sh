#!/bin/sh


wan_down_min=`uci get jw_qos.qos.wan_down_min`
wan_down_max=`uci get jw_qos.qos.wan_down_max`
wan_up_min=`uci get jw_qos.qos.wan_up_min`
wan_up_max=`uci get jw_qos.qos.wan_up_max`
lan_down_min=`uci get jw_qos.qos.lan_down_min`
lan_down_max=`uci get jw_qos.qos.lan_down_max`
#wan_proto=`uci get network.wan.proto`

#wan_interface="eth0.2"
#if [ "$wan_proto" != "dhcp" ];then
#	wan_interface="3g-wwan"
#fi

tc qdisc del dev br-lan root 1>/dev/null 2>/dev/null
#tc qdisc del dev $wan_interface root 1>/dev/null 2>/dev/null

#外网下载
if [ $wan_down_min != 0 -a $wan_down_max != 0 ];then
	
	tc qdisc add dev br-lan root handle 1: htb default 768
	tc class add dev br-lan parent 1: classid 1:1 htb rate 300mbit ceil 300mbit quantum 15000

	min=2
	max=253
	while [ $min -le $max ]
	do
		handleID=$min
		tc class add dev br-lan parent 1:1 classid 1:$handleID htb rate ${wan_down_min}kbps ceil ${wan_down_max}kbps
		#tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.10.$min flowid 1:$handleID
		tc filter add dev br-lan protocol ip parent 1:0 prio 1 handle $handleID fw flowid 1:$handleID
		iptables -D FORWARD -t mangle ! -s 10.10.10.254 -d 10.10.10.$min -j MARK --set-mark $handleID
		iptables -A FORWARD -t mangle ! -s 10.10.10.254 -d 10.10.10.$min -j MARK --set-mark $handleID
		min=`expr $min + 1`
	done
fi

#外网上传
if [ $wan_up_min != 0 -a $wan_up_max != 0 ];then
	
	tc qdisc add dev br-lan root handle 1: htb default 768
	tc class add dev br-lan parent 1: classid 1:1 htb rate 300mbit ceil 300mbit quantum 15000

	min=2
	max=253
	while [ $min -le $max ]
	do
		handleID=$(($min+256))
		tc class add dev br-lan parent 1:1 classid 1:$handleID htb rate ${wan_up_min}kbps ceil ${wan_up_max}kbps
		#tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.10.$min flowid 1:$handleID
		tc filter add dev br-lan protocol ip parent 1:0 prio 1 handle $handleID fw flowid 1:$handleID
		iptables -D PREROUTING -t mangle ! -d 10.10.10.254 -s 10.10.10.$min -j MARK --set-mark $handleID
		iptables -A PREROUTING -t mangle ! -d 10.10.10.254 -s 10.10.10.$min -j MARK --set-mark $handleID
		min=`expr $min + 1`
	done
fi

#内网下载
if [ $lan_down_min != 0 -a $lan_down_max != 0 ];then
	#tc qdisc del dev br-lan root 1>/dev/null 2>/dev/null
	tc qdisc add dev br-lan root handle 1: htb default 768
	tc class add dev br-lan parent 1: classid 1:1 htb rate 300mbit ceil 300mbit quantum 15000

	min=2
	max=253
	while [ $min -le $max ]
	do
		handleID=$(($min+512))
		tc class add dev br-lan parent 1:1 classid 1:$handleID htb rate ${lan_down_min}kbps ceil ${lan_down_max}kbps
		#tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.10.$min flowid 1:$handleID
		tc filter add dev br-lan protocol ip parent 1:0 prio 1 handle $handleID fw flowid 1:$handleID
		iptables -D POSTROUTING -t mangle -s 10.10.10.254 -d 10.10.10.$min -j MARK --set-mark $handleID
		iptables -A POSTROUTING -t mangle -s 10.10.10.254 -d 10.10.10.$min -j MARK --set-mark $handleID
		min=`expr $min + 1`
	done
fi

