#!/bin/sh


ls -l /usr/bin/wifidog
if [ $? -eq 0 ]
then
	exit
fi

rm -rf /var/lock/
mkdir /var/lock
opkg install /usr/hospital/ipk/libpcre_8.38-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/lighttpd_1.4.38-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/lighttpd-mod-fastcgi_1.4.38-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/lighttpd-mod-rewrite_1.4.38-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/libxml2_2.9.3-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-cgi_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-fastcgi_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-cli_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-ctype_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-pdo_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/libsqlite3_3120200-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-pdo-sqlite_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-session_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-sqlite3_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/php5-mod-tokenizer_5.6.19-2_ramips_24kec.ipk
opkg install /usr/hospital/ipk/zoneinfo-core_2016d-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/zoneinfo-asia_2016d-1_ramips_24kec.ipk
opkg install /usr/hospital/ipk/wifidog_1.3.0-1_ramips_24kec.ipk

mv /etc/init.d/wifidog /etc/init.d/wifidog.bak
mv /etc/php.ini /etc/php.ini.bak
mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.bak
opkg install /usr/hospital/ipk/luci-app-wifidog_1.0-1_ramips_24kec.ipk

mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.1
cp -a /usr/hospital/lighttpd.conf /etc/lighttpd/lighttpd.conf

mv /www/wifidog/index.php /www/wifidog/index.php.bak
cp -a /usr/hospital/auth /www/wifidog/
cp -a /usr/hospital/login /www/wifidog/
cp -a /usr/hospital/portal /www/wifidog/
cp -a /usr/hospital/ping /www/wifidog/
cp -a /usr/hospital/iptables /www/wifidog/

rm /etc/init.d/wifidog
cp -a /usr/hospital/wifidog /etc/init.d/wifidog

rm /etc/config/wifidog
cp -a /usr/hospital/wifidog.config /etc/config/wifidog

/etc/init.d/wifidog restart

