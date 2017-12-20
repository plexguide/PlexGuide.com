#!/bin/bash

bash /opt/plexguide/scripts/torrentvpn/vpnowners.sh

docker rm rtorrentvpn

#docker rm delugevpn

echo ymlprogram rtorrentvpn > /opt/plexguide/tmp.txt
echo ymldisplay rTorrentVPN >> /opt/plexguide/tmp.txt
echo ymlport 3000 >> /opt/plexguide/tmp.txt
bash /opt/plexguide/scripts/docker-no/program-installer.sh
bash /opt/plexguide/scripts/torrentvpn/move-ovpn.sh
clear
sudo usermod -aG docker nobody
