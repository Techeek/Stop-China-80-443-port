#!/bin/bash

COUNTRY="cn"
IPTABLES=/sbin/iptables
EGREP=/bin/egrep

if [ "$(id -u)" != "0" ]; then
   echo "you must be root" 1>&2
   exit 1
fi

resetrules() {
$IPTABLES -F
$IPTABLES -t nat -F
$IPTABLES -t mangle -F
$IPTABLES -X
}

resetrules

for c in $COUNTRY
do
        country_file=$c.zone

        IPS=$($EGREP -v "^#|^$" $country_file)
        for ip in $IPS
        do
           echo "blocking $ip"
           $IPTABLES -A INPUT -s $ip -p tcp --dport 80 -j DROP
           $IPTABLES -A INPUT -s $ip -p tcp --dport 443 -j DROP
        done
done

exit 0
