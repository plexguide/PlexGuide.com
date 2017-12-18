#!/bin/bash

bash /opt/plexguide/scripts/delugevpn/delugeowners.sh

docker rm delugevpn
#        docker rm rtorrentvpn
clear
echo ymlprogram delugevpn > /opt/plexguide/tmp.txt
echo ymldisplay DelugeVPN >> /opt/plexguide/tmp.txt
echo ymlport 8112 >> /opt/plexguide/tmp.txt
bash /opt/plexguide/scripts/docker-no/program-installer.sh
bash /opt/plexguide/scripts/delugevpn/move-ovpn.sh
clear
sudo usermod -aG docker nobody
