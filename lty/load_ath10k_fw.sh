#!/bin/sh
#add by Joey


insmod /root/10k3.19ko/compat.ko
insmod /root/10k3.19ko/cfg80211.ko
insmod /root/10k3.19ko/mac80211.ko
insmod /root/10k3.19ko/ath.ko
insmod /root/10k3.19ko/ath10k_core.ko
insmod /root/10k3.19ko/ath10k_pci.ko

sleep 1

min=1
max=2
while [ $min -le $max ]
do
	echo 1 >/sys/class/firmware/0000\:03\:00.0/loading
	cat /lib/firmware/ath10k/QCA988X/hw2.0/firmware-3.bin >/sys/class/firmware/0000\:03\:00.0/data
	echo 0 >/sys/class/firmware/0000\:03\:00.0/loading
	min=`expr $min + 1`
done

sleep 10

min=1
max=5
while [ $min -le $max ]
do
	sleep 1
		if test $(dmesg | grep "could not fetch board data 'ath10k/QCA988X/hw2.0/board.bin' (-2)" | wc -l) -eq 1
		then
			min1=1
			max1=2
			while [ $min1 -le $max1 ]
			do
				echo 1 >/sys/class/firmware/0000\:03\:00.0/loading
				cat /lib/firmware/ath10k/QCA988X/hw2.0/firmware-3.bin >/sys/class/firmware/0000\:03\:00.0/data
				echo 0 >/sys/class/firmware/0000\:03\:00.0/loading
				min1=`expr $min1 + 1`
			done
			exit 0
		fi
	min=`expr $min + 1`
done

sleep 1