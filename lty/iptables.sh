iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat

iptables -t nat -A PREROUTING -i br0 -p tcp --dport 80 -j DNAT --to 192.168.100.1:80
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
echo "1" > /proc/sys/net/ipv4/ip_forward
