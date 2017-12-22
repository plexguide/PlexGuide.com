#!/bin/bash

# create folders for torrents vpn directory
bash /opt/plexguide/scripts/torrentvpn/vpnowners.sh
# create and move openvpn setup files to vpn directory
bash /opt/plexguide/scripts/torrentvpn/openvpn-setup-deluge.sh

docker rm -f delugevpn

docker rm -f rtorrentvpn

echo ymlprogram delugevpn > /opt/plexguide/tmp.txt
echo ymldisplay DelugeVPN >> /opt/plexguide/tmp.txt
echo ymlport 8112 >> /opt/plexguide/tmp.txt
echo
echo
echo "            *****  Default password is: deluge  *****          "
echo
echo "   *****  Please give a few minutes to load all settings! *****"
echo
echo
bash /opt/plexguide/scripts/docker-no/program-installer.sh
#bash /opt/plexguide/scripts/torrentvpn/move-ovpnd.sh
#yes | apt-get install -y python-setuptools 1>/dev/null 2>&1
#python /opt/plexguide/scripts/tasks/seedtime/setup.py bdist_egg
#mv /opt/plexguide/scripts/tasks/seedtime/dist/SeedTime-2* /opt/appdata/vpn/config/plugins
clear
sudo usermod -aG docker nobody
