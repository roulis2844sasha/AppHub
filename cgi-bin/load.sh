#!/bin/bash
echo "Content-type: text/html"
echo ''
if [ -e "/sys/class/net/wlan0" ]; then
	protocol=`iwgetid --protocol wlan0`
	if grep -q "iface wlan0 inet static" /etc/network/interfaces; then
		onoff='on'
	else
		onoff='off'
	fi
	wifi='{"status":"enable","protocol":"'${protocol:30:-1}'","onoff":"'$onoff'"}'
else
	wifi='{"status":"disable"}'
fi

echo '{"wifi":'$wifi'}'
exit 0
