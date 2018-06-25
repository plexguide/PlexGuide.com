#!/bin/bash
echo
# create folders for torrents vpn directory
bash /opt/plexguide/scripts/torrentvpn/vpnowners.sh
# create and move openvpn setup files to vpn directory
bash /opt/plexguide/scripts/torrentvpn/openvpn-setup-rtorrent.sh

docker rm -f rtorrentvpn

docker rm -f delugevpn

echo ymlprogram rtorrentvpn > /opt/plexguide/tmp.txt
echo ymldisplay rTorrentVPN >> /opt/plexguide/tmp.txt
echo ymlport 3000 >> /opt/plexguide/tmp.txt
echo
echo
echo "    *****  Flood GUI is enabled by default - use port 3000  *****     "
echo
echo "    *****  Please give a few minutes to load all settings!  *****     "
echo
echo
bash /opt/plexguide/scripts/docker-no/program-installer.sh
#bash /opt/plexguide/scripts/torrentvpn/move-ovpnr.sh
clear
sudo usermod -aG docker nobody
