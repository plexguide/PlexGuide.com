#!/bin/bash

mkdir -p /opt/appdata/vpn
mkdir -p /opt/appdata/vpn/deluge
mkdir -p /opt/appdata/vpn/deluge/config
mkdir -p /opt/appdata/vpn/deluge/config/openvpn

# Move the PIA VPN files
mv /opt/plexguide/scripts/torrentvpn/openvpn /opt/appdata/vpn/config/

# move original setup files to new loctaion
 bash /opt/plexguide/scripts/torrentvpn/move-ovpn-deluge.sh
 rm -R /opt/appdata/delugevpn

 /sbin/modprobe iptable_mangle

# Use http://iknowwhatyoudownload.com to check if your IP is leaked after using
# deluge or use TorGuard's Check My Torrent IP Tool.

    # Using https://github.com/binhex/arch-delugevpn as original source

  # when opening delugevpn in a web browser the password is deluge
