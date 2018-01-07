#!/bin/bash

# Create directories for deluge
mkdir -p /opt/appdata/vpn
mkdir -p /opt/appdata/vpn/deluge
mkdir -p /opt/appdata/vpn/deluge/config
mkdir -p /opt/appdata/vpn/deluge/config/openvpn


 /sbin/modprobe iptable_mangle
