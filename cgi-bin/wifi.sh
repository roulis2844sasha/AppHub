if [ $1 == 'start' ]; then


echo 'Интерфейс wifi'
read wifi
echo 'Интерфейс с интернетом'
read lan
echo 'Название точки'
read ssid
echo 'Пароль точки'
read pass
echo "bind-interfaces
interface=$wifi
dhcp-range=192.168.10.2,192.168.10.5" > /etc/dnsmasq.conf
echo "interface=$wifi
driver=nl80211
ssid=$ssid
hw_mode=g
channel=6
wpa=2
wpa_passphrase=$pass" > /etc/hostapd.conf
echo "#dns=dnsmasq" >> /etc/NetworkManager/NetworkManager.conf
restart network-manager


    ifconfig $wifi 192.168.10.1
    service dnsmasq restart
    sysctl net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o $lan -j MASQUERADE
    hostapd /etc/hostapd.conf
fi
if [ $1 == 'stop' ]; then
    iptables -D POSTROUTING -t nat -o $lan -j MASQUERADE
    sysctl net.ipv4.ip_forward=0
    service dnsmasq stop
    service hostapd stop
fi
