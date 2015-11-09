sudo gedit /etc/dnsmasq.conf :

echo "bind-interfaces
interface=wlan0
dhcp-range=192.168.10.2,192.168.10.5" > /etc/dnsmasq.conf
echo "interface=wlan0
driver=nl80211
ssid=Linux
hw_mode=g
channel=6
wpa=2
wpa_passphrase=12345678" > /etc/hostapd.conf
echo "#dns=dnsmasq" >> /etc/NetworkManager/NetworkManager.conf
restart network-manager
if [ $1 == 'start' ]; then
    ifconfig wlan0 192.168.10.1
    service dnsmasq restart
    sysctl net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  #Вместо eth0 нужно прописать твой интерфейс через который подключается Интернет
    hostapd /etc/hostapd.conf
fi
if [ $1 == 'stop' ]; then
    iptables -D POSTROUTING -t nat -o eth0 -j MASQUERADE    #Вместо eth0 нужно прописать твой интерфейс через который подключается Интернет
    sysctl net.ipv4.ip_forward=0
    service dnsmasq stop
    service hostapd stop
fi
