#!/bin/bash

bash /opt/plexguide/scripts/delugevpn/rtorrentowners.sh

docker rm rtorrentvpn
docker rm delugevpn
clear
echo ymlprogram rtorrentvpn > /opt/plexguide/tmp.txt
echo ymldisplay rTorrentVPN >> /opt/plexguide/tmp.txt
echo ymlport 9080 >> /opt/plexguide/tmp.txt
bash /opt/plexguide/scripts/docker-no/program-installer.sh
bash /opt/plexguide/scripts/delugevpn/move-ovpn.sh
clear
sudo usermod -aG docker nobody
