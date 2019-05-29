#!/bin/bash

curl https://adaway.org/hosts.txt | tee /data/hosts
curl https://hosts-file.net/ad_servers.txt | tee -a /data/hosts
curl https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts\&showintro=0\&mimetype=plaintext | tee -a /data/hosts

sed -i 's///g' /data/hosts

if [ -f /var/run/dnsmasq.pid ]
then
    kill -1 `cat /var/run/dnsmasq.pid`
fi
