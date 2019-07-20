#!/bin/bash
#
# Title:      PGBlitz (PG DNS chnager)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# Coder :     MrDoob | Freelaancer Coder TechLead
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

tee <<-EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⌛  Verifiying PG DNS ( resolv.conf ) changer
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

echo "Updating packages"
apt-get update -yqq >/dev/null
echo "Upgrading packages"
apt-get upgrade -yqq >/dev/null
echo "Dist-Upgrading packages"
apt-get dist-upgrade -yqq >/dev/null
echo "Autoremove old Updates"
apt-get autoremove -yqq >/dev/null
echo "install complete"

tee <<-EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	🚀 PG DNS ( resolv.conf ) changer 
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	
	[1] Google DNS IPv4
	[2] Google DNS IPv4 + IPv6
	[3] Cloudflare DNS IPv4
	[4] Cloudflare DNS IPv4 + IPv6
	[5] OpenDNS IPv4
	[6] Comodo Secure DNS
	
	[Z] Exit

	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

if [ "$typed" == "1" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 8.8.8.8\' /etc/resolv.conf
	sed -i '$a\nameserver 8.8.4.4\' /etc/resolv.conf
elif [ "$typed" == "2" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 8.8.8.8\' /etc/resolv.conf
	sed -i '$a\nameserver 8.8.4.4\' /etc/resolv.conf
	sed -i '$a\nameserver2001:4860:4860::8844\' /etc/resolv.conf
	sed -i '$a\nameserver2001:4860:4860::8888\' /etc/resolv.conf
elif [ "$typed" == "3" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 1.1.1.1\' /etc/resolv.conf
	sed -i '$a\nameserver 1.0.0.1\' /etc/resolv.conf
elif [ "$typed" == "4" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 1.1.1.1\' /etc/resolv.conf
	sed -i '$a\nameserver 1.0.0.1\' /etc/resolv.conf
	sed -i '$a\nameserver 2606:4700:4700::1111\' /etc/resolv.conf
	sed -i '$a\nameserver 2606:4700:4700::1001\' /etc/resolv.conf
elif [ "$typed" == "5" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 208.67.222.222\' /etc/resolv.conf
	sed -i '$a\nameserver 208.67.220.220\' /etc/resolv.conf
elif [ "$typed" == "6" ]; then
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '/nameserver/s/^#*/#/g' /etc/resolv.conf
	sed -i '$a\nameserver 8.26.56.26\' /etc/resolv.conf
	sed -i '$a\nameserver 8.20.247.20\' /etc/resolv.conf
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
	exit
else
	bash /opt/plexguide/menu/tools/tools.sh
	exit
fi
bash /opt/plexguide/menu/tools/tools.sh
exit
