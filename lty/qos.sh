#!/bin/sh
#add by Joey

USAGE() {
	echo "	error:	must be have 1 parameter or more"
	echo "	usage:	qos.sh 1 100"
	exit 1
}

if [ $# -lt 1 ] ; then 
	USAGE
fi 

if [ $1 == 0 ] ; then 
	tc qdisc del dev br0 root 1>/dev/null 2>/dev/null
	exit 0
fi 

echo "init qos ..."
tc qdisc del dev br0 root 1>/dev/null 2>/dev/null
tc qdisc add dev br0 root handle 1: htb default 99
tc class add dev br0 parent 1: classid 1:1 htb rate 300mbit ceil 300mbit quantum 15000

min=100
max=163
while [ $min -le $max ]
do
	tc class add dev br0 parent 1:1 classid 1:$min htb rate $1kbit ceil 5mbit
	tc filter add dev br0 protocol ip parent 1:0 prio 1 u32 match ip dst 192.168.0.$min/32 flowid 1:$min
    min=`expr $min + 1`
done


service() {
	tc qdisc del dev eth0 root 1>/dev/null 2>/dev/null
	tc qdisc add dev eth0 root handle 1: prio
	tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 900 0xffff flowid 1:1
	tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 6800 0xffff flowid 1:2
	tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match u32 0 0 flowid 1:3

}
