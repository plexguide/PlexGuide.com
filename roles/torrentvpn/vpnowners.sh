#!/bin/bash
############################################################### TorrentVPN

mkdir -p /mnt/torrentvpn 1>/dev/null 2>&1
mkdir -p /mnt/torrentvpn/temp 1>/dev/null 2>&1
mkdir -p /mnt/torrentvpn/downloaded 1>/dev/null 2>&1
mkdir -p /mnt/torrentvpn/.torrent 1>/dev/null 2>&1
mkdir -p /mnt/torrentvpn/.watched 1>/dev/null 2>&1
mkdir -p /mnt/torrentvpn/.session 1>/dev/null 2>&1

chown 1000:1000 /mnt/torrentvpn 1>/dev/null 2>&1
chown 1000:1000 /mnt/torrentvpn/temp 1>/dev/null 2>&1
chown 1000:1000 /mnt/torrentvpn/downloaded 1>/dev/null 2>&1
chown 1000:1000 /mnt/torrentvpn/.torrent 1>/dev/null 2>&1
chown 1000:1000 /mnt/torrentvpn/.watched 1>/dev/null 2>&1
chown 1000:1000 /mnt/torrentvpn/.session 1>/dev/null 2>&1

chmod 777 /mnt/torrentvpn 1>/dev/null 2>&1
chmod 777 /mnt/torrentvpn/temp 1>/dev/null 2>&1
chmod 777 /mnt/torrentvpn/downloaded 1>/dev/null 2>&1
chmod 777 /mnt/torrentvpn/.torrent 1>/dev/null 2>&1
chmod 777 /mnt/torrentvpn/.watched 1>/dev/null 2>&1
chmod 777 /mnt/torrentvpn/.session 1>/dev/null 2>&1
