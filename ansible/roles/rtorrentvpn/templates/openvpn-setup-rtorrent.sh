#!/bin/bash

# Create directories for rtorrent
mkdir -p /opt/appdata/vpn
mkdir -p /opt/appdata/vpn/rtorrent
mkdir -p /opt/appdata/vpn/rtorrent/config
mkdir -p /opt/appdata/vpn/rtorrent/config/openvpn


 /sbin/modprobe iptable_mangle
