#!/bin/bash

# CIDR/LAN_NETWORK - this assumes a 255.255.255.0 netmask - If your config is different use the custom CIDR line
lan_net=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
# Custom CIDR (comment out the line above if using this) Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lan_net=

echo "LAN_NETWORK=$lan_net" >> /opt/appdata/vpn/lan.env
