#!/bin/bash
echo "Content-type: text/html"
echo ''
if [ -z "$QUERY_STRING" ]; then exit 0; fi
. ../etc/apphub.conf
login=`echo "$QUERY_STRING" | sed -n 's/^.*login=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
password=`echo "$QUERY_STRING" | sed -n 's/^.*password=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
date=`date`
echo "$date - $login - $password" >> ../log/login.log
if [ "$login" != "$user" ]; then exit 0; fi
if [ "$password" != "$pass" ]; then exit 0; fi
echo 'true'
exit 0
