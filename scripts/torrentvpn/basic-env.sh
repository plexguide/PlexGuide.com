#!/bin/bash

# Get local Username
localuname=`id -u -n`
# Get PUID
PUID=`id -u $localuname`
# Get GUID
PGID=`id -g $localuname`
# Get Hostname
thishost=`hostname`
# Get IP Address
locip=`hostname -I | awk '{print $1}'`
# Get Time Zone
time_zone=`cat /etc/timezone`

# CIDR - this assumes a 255.255.255.0 netmask - If your config is different use the custom CIDR line
lannet=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
# Custom CIDR (comment out the line above if using this)
# Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lannet=

# Get Private Internet Access Info
#read -p "What is your PIA Username?: " pia_username
#read -s -p "What is your PIA Password? (Will not be echoed): " pia_password
#read -p "What Remote server do you want to use? (e.g france): " vpn_remote_choice
#printf "\n\n"

# Get info needed for PLEX Official image
#read -p "Which PLEX release do you want to run? By default 'public' will be used. (latest, public, plexpass): " pmstag
#read -p "If you have PLEXPASS what is your Claim Token: (Optional) " pmstoken
# If not set - set PMS Tag to Public:
#if [ -z "$pmstag" ]; then
#   pmstag=public
#fi

# Get the info for the style of Portainer to use
##read -p "Which style of Portainer do you want to use? By default 'No Auth' will be used. (noauth, auth): " portainerstyle
##if [ -z "$portainerstyle" ]; then
##   portainerstyle=--no-auth
##elif [ $portainerstyle == "noauth" ]; then
##   portainerstyle=--no-auth
##elif [ $portainerstyle == "auth" ]; then
##   portainerstyle=
##fi

# Create the .env file
echo "Creating the .env file with the values we have gathered"
printf "\n"
echo "LOCALUSER=$localuname" >> /opt/appdata/.env
echo "HOSTNAME=$thishost" >> /opt/appdata/.env
echo "IP_ADDRESS=$locip" >> /opt/appdata/.env
echo "PUID=$PUID" >> /opt/appdata/.env
echo "PGID=$PGID" >> /opt/appdata/.env
echo "PWD=$PWD" >> /opt/appdata/.env
#echo "VPN_USER=$pia_username" >> .env
#echo "VPN_PASS=$pia_password" >> .env
#echo "VPN_REMOTE=$vpn_remote_choice" >> .env
echo "LAN_NETWORK=$lannet" >> /opt/appdata/.env
echo "TZ=$time_zone" >> /opt/appdata/.env
#echo "PMSTAG=$pmstag" >> .env
#echo "PMSTOKEN=$pmstoken" >> .env
##echo "PORTAINERSTYLE=$portainerstyle" >> .env
echo ".env file creation complete"
printf "\n\n"
