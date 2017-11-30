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
# Custom CIDR (comment out the line above if using this) Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lannet=


# Get info needed for PLEX Official image
read -p "Which PLEX release do you want to run? By default 'public' will be used. (latest, public, plexpass): " pmstag
read -p "If you have PLEXPASS what is your Claim Token: (Optional) " pmstoken
# If not set - set PMS Tag to Public:
if [ -z "$pmstag" ]; then
   pmstag=public
fi


# Create the .env file
echo "Creating the .env file with the values we have gathered"
printf "\n"
echo "LOCALUSER=$localuname" >> .env
echo "HOSTNAME=$thishost" >> .env
echo "IP_ADDRESS=$locip" >> .env
echo "PUID=$PUID" >> .env
echo "PGID=$PGID" >> .env
echo "PWD=$PWD" >> .env
echo "PIAUNAME=$piauname" >> .env
echo "PIAPASS=$piapass" >> .env
echo "CIDR_ADDRESS=$lannet" >> .env
echo "TZ=$time_zone" >> .env
echo "PMSTAG=$pmstag" >> .env
echo "PMSTOKEN=$pmstoken" >> .env
echo ".env file creation complete"
printf "\n\n"


sudo cp .env /opt/.environments/.plex-env
sudo cp .env /opt/plexguide/scripts/docker/.env

printf "Setup Complete - Open a browser and go to: \n\n"
printf "http://$locip OR http://$thishost \n"
