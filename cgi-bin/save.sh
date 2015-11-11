#!/bin/bash
echo "Content-type: text/html"
echo ''
if [ -z "$QUERY_STRING" ]; then exit 0; fi
root=`echo "$QUERY_STRING" | sed -n 's/^.*root=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
if [ -z "$root" ]; then exit 0; fi
. ../etc/apphub.conf
onoff=`echo "$QUERY_STRING" | sed -n 's/^.*onoff=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
echo "$root" | sudo -S sh -c 'echo "#!/bin/bash\\nPATH="$PATH:/usr/bin/"\\ncase \"\$1\" in\\nstart)\\n	p=\`pgrep hostapd\`\\n	if [ \"\$p\" == \"\" ];then\\n	nmcli nm wifi off\\n	rfkill unblock wlan\\n	ifconfig '$iwifi' 192.168.10.1\\n	service dnsmasq restart\\n	sysctl net.ipv4.ip_forward=1\\n	iptables -t nat -A POSTROUTING -o '$ilan' -j MASQUERADE\\n	hostapd /etc/hostapd.conf\\n	fi\\n;;\\nstop)\\n	iptables -D POSTROUTING -t nat -o '$ilan' -j MASQUERADE\\n	sysctl net.ipv4.ip_forward=0\\n	service dnsmasq stop\\n	service hostapd stop\\n;;\\nrestart)\\n"\$0" stop\\n"\$0" start\\n;;\\nesac\\nexit 0" > /etc/init.d/apphub'
echo "$root" | sudo -S chmod +x /etc/init.d/apphub
echo "$root" | sudo -S nmcli nm wifi off
echo "$root" | sudo -S rfkill unblock wlan
if [ "$onoff" == "1" ]; then
	ssid=`echo "$QUERY_STRING" | sed -n 's/^.*ssid=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
	wpa=`echo "$QUERY_STRING" | sed -n 's/^.*wpa=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
	echo "$root" | sudo -S sed -i "s/wssid='.*'/wssid='"$ssid"'/g" ../etc/apphub.conf
	echo "$root" | sudo -S sh -c 'echo "bind-interfaces\\ninterface='$iwifi'\\ndhcp-range=192.168.10.2,192.168.10.5" > /etc/dnsmasq.conf'
	if [ "$wpa" == "1" ]; then
		wpa_passphrase=`echo "$QUERY_STRING" | sed -n 's/^.*wpa_passphrase=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
		echo "$root" | sudo -S sed -i "s/wpass='.*'/wpass='"$wpa_passphrase"'/g" ../etc/apphub.conf
		echo "$root" | sudo -S sh -c 'echo "interface='$iwifi'\\ndriver=nl80211\\nssid='$ssid'\\nhw_mode=g\\nchannel=6\\nwpa=2\\nwpa_passphrase='$wpa_passphrase'" > /etc/hostapd.conf'
	else
		echo "$root" | sudo -S sh -c 'echo "interface='$iwifi'\\ndriver=nl80211\\nssid='$ssid'\\nhw_mode=g\\nchannel=6\\nwpa=0" > /etc/hostapd.conf'
	fi
	echo "$root" | sudo -S service apphub start
else
	echo "$root" | sudo -S rm /etc/hostapd.conf
	echo "$root" | sudo -S rm /etc/dnsmasq.conf
	echo "$root" | sudo -S service apphub stop
fi
echo "$root" | sudo -S update-rc.d apphub defaults
echo "$QUERY_STRING";
exit 0
