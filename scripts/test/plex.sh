#!/bin/bash
# Get local Username
local_username=`id -u -n`
# Get PUID
PUID=`id -u $local_username`
# Get GUID
PGID=`id -g $local_username`
# Get Hostname
this_host=`hostname`
# Get IP Address
local_ip=`hostname -I | awk '{print $1}'`
# Get Time Zone
time_zone=`cat /etc/timezone`
# CIDR - this assumes a 255.255.255.0 netmask - If your config is different use the custom CIDR line
lan_net=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
# Custom CIDR (comment out the line above if using this) Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lan_net=


# Get info needed for PLEX Official image
read -p "Which PLEX release do you want to run? By default 'public' will be used. (latest, public, plexpass): " pms_tag
echo
echo
read -p "If you have PLEXPASS what is your Claim Token: (Visit http://plex.tv/claim or press Enter) " pms_token
# If not set - set PMS Tag to Public:
if [ -z "$pms_tag" ]; then
   pms_tag=public
fi


# Create the .env file
echo "Creating the .env file with the values we have gathered"
printf "\n"
echo "LOCAL_USER=$local_username" >> .env
echo "HOSTNAME=$this_host" >> .env
echo "IP_ADDRESS=$local_ip" >> .env
echo "PUID=$PUID" >> .env
echo "PGID=$PGID" >> .env
echo "PWD=$PWD" >> .env
#echo "PIA_USERNAME=$pia_username" >> .env
#echo "PIA_PASSWORD=$pia_password" >> .env
echo "CIDR_ADDRESS=$lan_net" >> .env
echo "TZ=$time_zone" >> .env
echo "PMS_TAG=$pms_tag" >> .env
echo "PMS_TOKEN=$pms_token" >> .env
echo ".env file creation complete"
printf "\n\n"

 cp .env /opt/appdata/.plex-env
#sudo cp .env /opt/plexguide/scripts/docker/.env
cat /opt/appdata/.plex-env >> /opt/plexguide/scripts/docker/.env

printf "Setup Complete - Open a browser and go to: \n\n"
printf "http://$local_ip OR http://$this_host \n"
