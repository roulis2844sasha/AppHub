#!/bin/bash
echo "Content-type: text/html"
echo ''
if [ -z "$QUERY_STRING" ]; then exit 0; fi
. ../etc/apphub.conf
onoff=`echo "$QUERY_STRING" | sed -n 's/^.*onoff=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
if [ "$onoff" == "1" ]; then
	echo "$root" | sudo -S nmcli nm wifi off
	echo "$root" | sudo -S rfkill unblock wlan
	echo "$root" | sudo -S sh -c 'echo "auto '$iwifi'\\n	iface '$iwifi' inet static\\n	address 192.168.55.1\\n	netmask 255.255.255.0" >> /etc/network/interfaces'
	echo "$root" | sudo -S sh -c 'echo "DAEMON_CONF=/etc/hostapd/hostapd.conf" >> /etc/default/hostapd'
	echo "$root" | sudo -S sh -c 'echo "interface='$iwifi'
# имя нашей беспроводной сети
ssid=anonymous_ap
hw_mode=g
# Предварительно рекомендуется выявить минимально загруженный канал
channel=11
# Фильтрация по MAC-адресам в данном примере отключена
macaddr_acl=0
# Для организации закрытой сети следует выставить эту опцию в значение 1 и раскомментировать нижеследующие строки
wpa=0
#wpa_key_mgmt=WPA-PSK
#wpa_pairwise=TKIP CCMP
#wpa_ptk_rekey=600
# Собственно, задаем пароль
#wpa_passphrase=hidemyass" >> /etc/hostapd/hostapd.conf'
	echo "$root" | sudo -S sh -c 'echo "option domain-name \"anonymous-ap.local\";
subnet 192.168.55.0 netmask 255.255.255.0 {
  range 192.168.55.10 192.168.55.100;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  option routers 192.168.55.1;
  interface '$iwifi';
}" > /etc/dhcp/dhcpd.conf'
	echo "$root" | sudo -S sh -c 'echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf'
else
	echo "$root" | sudo -S sed -i "/auto $iwifi/d" /etc/network/interfaces
	echo "$root" | sudo -S sed -i "/iface $iwifi inet static/d" /etc/network/interfaces
	echo "$root" | sudo -S sed -i "/address 192.168.55.1/d" /etc/network/interfaces
	echo "$root" | sudo -S sed -i "/netmask 255.255.255.0/d" /etc/network/interfaces
	echo "$root" | sudo -S sed -i "/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/d" /etc/default/hostapd
	echo "$root" | sudo -S rm /etc/hostapd/hostapd.conf
	echo "$root" | sudo -S rm /etc/dhcp/dhcpd.conf
	echo "$root" | sudo -S sed -i "/net.ipv4.ip_forward=1/d" /etc/sysctl.conf
fi
echo "$root" | sudo -S service hostapd restart
echo "$root" | sudo -S /etc/init.d/isc-dhcp-server restart
echo "$root" | sudo -S sysctl -p
echo "$QUERY_STRING"
exit 0
