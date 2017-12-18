#!/bin/bash
############################################################### DelugeVPN

chown 1000:1000 /mnt/rtorrentvpn 1>/dev/null 2>&1
chown 1000:1000 /mnt/rtorrentvpn/temp 1>/dev/null 2>&1
chown 1000:1000 /mnt/rtorrentvpn/downloaded 1>/dev/null 2>&1
chown 1000:1000 /mnt/rtorrentvpn/torrent 1>/dev/null 2>&1

chmod 777 /mnt/rtorrentvpn 1>/dev/null 2>&1
chmod 777 /mnt/rtorrentvpn/temp 1>/dev/null 2>&1
chmod 777 /mnt/rtorrentvpn/downloaded 1>/dev/null 2>&1
chmod 777 /mnt/rtorrentvpn/torrent 1>/dev/null 2>&1
