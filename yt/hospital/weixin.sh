#!/bin/sh


check_network () {

        while [ "1" = "1" ]
        do
                ping www.baidu.com -c 1 | grep seq
                if [ $? -eq 0 ]
                then
                        return
                fi
                sleep 5
        done
}

check_network

rm -rf /www/www
ln -s /mnt/mmcblk0p1/online /www/wifidog/www

pgrep wifidog

if [ $? == 1 ]
then 
	wifidog
fi

sleep 3

iptables -t filter -A  WiFiDog_br-lan_AuthServers -d short.weixin.qq.com,long.weixin.qq.com,szlong.weixin.qq.com,szshort.weixin.qq.com,mp.weixin.qq.com,res.wx.qq.com -j ACCEPT
iptables -t nat -A WiFiDog_br-lan_AuthServers  -d short.weixin.qq.com,long.weixin.qq.com,szlong.weixin.qq.com,szshort.weixin.qq.com,mp.weixin.qq.com,res.wx.qq.com -j ACCEPT


bmd_url=$(uci get wifidog.settings.bmd_url) 
iptables -t filter -A  WiFiDog_br-lan_AuthServers -d $bmd_url -j ACCEPT
iptables -t nat -A WiFiDog_br-lan_AuthServers  -d $bmd_url -j ACCEPT


ps | grep iptables.sh | awk -F ' ' '{print $1}' | xargs kill -9
/usr/hospital/iptables.sh &

