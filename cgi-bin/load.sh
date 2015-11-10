#!/bin/bash
echo "Content-type: text/html"
echo ''
. ../etc/apphub.conf
if [ -e "/sys/class/net/wlan0" ]; then
	protocol=`iwgetid --protocol wlan0`
	if [ -e "/etc/dnsmasq.conf" ]; then
		onoff='on'
	else
		onoff='off'
	fi
	wifi='{"status":"enable","protocol":"'${protocol:30:-1}'","onoff":"'$onoff'","wssid":"'$wssid'","wpass":"'$wpass'"}'
else
	wifi='{"status":"disable"}'
fi

echo '{"wifi":'$wifi'}'
exit 0
