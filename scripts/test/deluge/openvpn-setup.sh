!#/bin/bash

#mkdir -p /opt/appdata/delugevpn
#mkdir -p /opt/appdata/delugevpn/config/openvpn

# Move the PIA VPN files
`mv 'Open Configuration Files/France.ovpn' /opt/appdata/delugevpn/config/openvpn/france.ovpn`
`mv 'Open Configuration Files/ca.rsa.2048.crt' /opt/appdata/delugevpn/config/openvpn/ca.rsa.2048.crt`
`mv 'Open Configuration Files/crl.rsa.2048.pem' /opt/appdata/delugevpn/config/openvpn/crl.rsa.2048.pem`

 /sbin/modprobe iptable_mangle

  # use http://iknowwhatyoudownload.com to check if there your ip is leaked after using deluge
  # using https://github.com/binhex/arch-delugevpn as original source
