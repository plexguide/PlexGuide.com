#!/bin/bash

mkdir -p /opt/appdata/delugevpn
mkdir -p /opt/appdata/delugevpn/config

# Move the PIA VPN files
`mv '/opt/plexguide/scripts/openvpn' /opt/appdata/delugevpn/config/Remotes`
#`mv '/opt/plexguide/scripts/openvpn' /opt/appdata/delugevpn/config/`

# chmod +x /opt/plexguide/scripts/test/deluge/move-ovpn.sh
 bash /opt/plexguide/scripts/test/deluge/move-ovpn.sh

 /sbin/modprobe iptable_mangle

# Use http://iknowwhatyoudownload.com to check if your IP is leaked after using
# deluge or use TorGuard's Check My Torrent IP Tool.

    # Using https://github.com/binhex/arch-delugevpn as original source

  # when opening delugevpn in a web browser the password is deluge
