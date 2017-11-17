#!/bin/bash

mkdir -p /opt/appdata/delugevpn
mkdir -p /opt/appdata/delugevpn/config

 chmod +x /opt/plexguide/scripts/test/deluge/deluge-env.sh
 ./deluge-env.sh

# Move the PIA VPN files
#`mv '/opt/plexguide/scripts/test/deluge/delugevpn.yml' /opt/plexguide/scripts/docker`
`mv '/opt/plexguide/scripts/test/deluge/.env' /var/plexguide`
`mv '/opt/plexguide/scripts/test/deluge/openvpn' /opt/appdata/delugevpn/config/openvpn`
#`mv '/opt/plexguide/scripts/test/deluge/openvpn/France.ovpn' /opt/appdata/delugevpn/config/openvpn/france.ovpn`
#`mv '/opt/plexguide/scripts/test/deluge/openvpn/ca.rsa.2048.crt' /opt/appdata/delugevpn/config/openvpn/ca.rsa.2048.crt`
#`mv '/opt/plexguide/scripts/test/deluge/openvpn/crl.rsa.2048.pem' /opt/appdata/delugevpn/config/openvpn/crl.rsa.2048.pem`

 /sbin/modprobe iptable_mangle

  # use http://iknowwhatyoudownload.com to check if there your ip is leaked after using deluge
  # using https://github.com/binhex/arch-delugevpn as original source
  # sudo chmod +x /opt/plexguide/scripts/test/deluge/openvpn-setup.sh
  # cd /opt/plexguide/scripts/test/deluge/
  # sudo ./openvpn-setup.sh

  # when opening delugevpn in a web browser the password is deluge
