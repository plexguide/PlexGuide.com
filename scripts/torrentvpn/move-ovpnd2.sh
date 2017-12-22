#!/bin/bash

cp /opt/appdata/vpn/deluge/config/Remotes/ca.rsa.2048.crt /opt/appdata/vpn/deluge/config/openvpn/
cp /opt/appdata/vpn/deluge/config/Remotes/crl.rsa.2048.pem /opt/appdata/vpn/deluge/config/openvpn/

## Uncomment remote server that you want to use.

# mv /opt/appdata/vpn/deluge/config/Remotes/CA\ Montreal.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/CA\ Toronto.ovpn /opt/appdata/vpn/deluge/config/openvpn/
 cp /opt/appdata/vpn/deluge/config/Remotes/Netherlands.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/Switzerland.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/Sweden.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/France.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/Romania.ovpn /opt/appdata/vpn/deluge/config/openvpn/
# mv /opt/appdata/vpn/deluge/config/Remotes/Israel.ovpn /opt/appdata/vpn/deluge/config/openvpn/
