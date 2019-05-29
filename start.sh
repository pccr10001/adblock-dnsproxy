#!/bin/bash

# update blacklist
if [ ! -f "/data/hosts" ]
then
    /usr/bin/update_blacklist.sh
fi

# load template
if [ ! -f "/data/dnsmasq.conf" ]
then
    cp /template/* /data/
    if [ ! -f /data/ssl/fullchain.pem ]
    then
        cp -r /template/ssl /data/
    fi
fi

# start cronjob
cron

# DNS Daemon
dnsmasq -k -C /data/dnsmasq.conf &

# DoH daemon for nginx reverse proxy
doh-httpproxy --upstream-resolver 127.0.0.1:5353 --port 8080 --listen-address 0.0.0.0 --trusted &

# DoT and DoT daemon
dnsproxy -u 127.0.0.1:5353 -l 0.0.0.0 -p 0 --tls-port 853 --https-port 8443 --tls-crt=/data/ssl/fullchain.pem --tls-key=/data/ssl/privkey.pem
