#!/bin/bash

cp /opt/appdata/vpn/rtorrent/config/Remotes/ca.rsa.2048.crt /opt/appdata/vpn/rtorrent/config/openvpn/
cp /opt/appdata/vpn/rtorrent/config/Remotes/crl.rsa.2048.pem /opt/appdata/vpn/rtorrent/config/openvpn/

## Uncomment remote server that you want to use.

# mv /opt/appdata/vpn/rtorrent/config/Remotes/CA\ Montreal.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/CA\ Toronto.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
 cp /opt/appdata/vpn/rtorrent/config/Remotes/Netherlands.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/Switzerland.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/Sweden.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/France.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/Romania.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
# mv /opt/appdata/vpn/rtorrent/config/Remotes/Israel.ovpn /opt/appdata/vpn/rtorrent/config/openvpn/
