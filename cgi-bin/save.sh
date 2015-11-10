#!/bin/bash
echo "Content-type: text/html"
echo ''
if [ -z "$QUERY_STRING" ]; then exit 0; fi
. ../etc/apphub.conf
onoff=`echo "$QUERY_STRING" | sed -n 's/^.*onoff=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
if [ "$onoff" == "1" ]; then
	ssid=`echo "$QUERY_STRING" | sed -n 's/^.*ssid=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
	wpa=`echo "$QUERY_STRING" | sed -n 's/^.*wpa=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
	echo "$root" | sudo -S sed -i "s/wssid='.*'/wssid='"$ssid"'/g" ../etc/apphub.conf
	echo "$root" | sudo -S nmcli nm wifi off
	echo "$root" | sudo -S rfkill unblock wlan
	echo "$root" | sudo -S sh -c 'echo "bind-interfaces\\ninterface='$iwifi'\\ndhcp-range=192.168.10.2,192.168.10.5" > /etc/dnsmasq.conf'
	if [ "$wpa" == "1" ]; then
		wpa_passphrase=`echo "$QUERY_STRING" | sed -n 's/^.*wpa_passphrase=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
		echo "$root" | sudo -S sed -i "s/wpass='.*'/wpass='"$wpa_passphrase"'/g" ../etc/apphub.conf
		echo "$root" | sudo -S sh -c 'echo "interface='$iwifi'\\ndriver=nl80211\\nssid='$ssid'\\nhw_mode=g\\nchannel=6\\nwpa=2\\nwpa_passphrase='$wpa_passphrase'" > /etc/hostapd.conf'
	else
		echo "$root" | sudo -S sh -c 'echo "interface='$iwifi'\\ndriver=nl80211\\nssid='$ssid'\\nhw_mode=g\\nchannel=6\\nwpa=0" > /etc/hostapd.conf'
	fi
	echo "$root" | sudo -S ifconfig $iwifi 192.168.10.1
	echo "$root" | sudo -S service dnsmasq restart
	echo "$root" | sudo -S sysctl net.ipv4.ip_forward=1
	echo "$root" | sudo -S iptables -t nat -A POSTROUTING -o $ilan -j MASQUERADE
	echo "$root" | sudo -S hostapd /etc/hostapd.conf
else
	echo "$root" | sudo -S rm /etc/hostapd.conf
	echo "$root" | sudo -S rm /etc/dnsmasq.conf
	echo "$root" | sudo -S iptables -D POSTROUTING -t nat -o $ilan -j MASQUERADE
	echo "$root" | sudo -S sysctl net.ipv4.ip_forward=0
	echo "$root" | sudo -S service dnsmasq stop
	echo "$root" | sudo -S service hostapd stop
fi
echo "$QUERY_STRING";
exit 0
