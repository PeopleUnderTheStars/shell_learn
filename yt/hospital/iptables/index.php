<?php
	exec("iptables -t filter -I  WiFiDog_br-lan_AuthServers 1 -d captive.apple.com -j ACCEPT");
        exec("iptables -t nat -I WiFiDog_br-lan_AuthServers 1 -d captive.apple.com -j ACCEPT");
?>
