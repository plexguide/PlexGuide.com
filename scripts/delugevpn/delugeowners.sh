#!/bin/bash
############################################################### DelugeVPN

chown 1000:1000 /mnt/delugevpn 1>/dev/null 2>&1
chown 1000:1000 /mnt/delugevpn/temp 1>/dev/null 2>&1
chown 1000:1000 /mnt/delugevpn/downloaded 1>/dev/null 2>&1
chown 1000:1000 /mnt/delugevpn/torrent 1>/dev/null 2>&1

chmod 777 /mnt/delugevpn 1>/dev/null 2>&1
chmod 777 /mnt/delugevpn/temp 1>/dev/null 2>&1
chmod 777 /mnt/delugevpn/downloaded 1>/dev/null 2>&1
chmod 777 /mnt/delugevpn/torrent 1>/dev/null 2>&1
