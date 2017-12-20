#!/bin/bash

mv /opt/appdata/delugevpn/ /opt/appdata/vpn
mv /opt/appdata/vpn/.deluge-env /opt/appdata/vpn/.vpn-env
mv /opt/appdata/delugevpn/.deluge-env /opt/appdata/vpn/.vpn-env

## For moving original files to new locations
