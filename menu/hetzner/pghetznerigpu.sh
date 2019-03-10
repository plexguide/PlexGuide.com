#!/bin/bash
#
# Title:      PGBlitz (Hetzner iGPU / GPU)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# Coder :     MrDoob | Freelaancer Coder TechLead
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying PG Hetzner iGPU / GPU HW-Transcode !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

echo "Upgdating packages" 
	apt-get update -yqq
echo "Upgrading packages"
	apt-get upgrade -yqq
echo "Dist-Upgrading packages"   
	apt-get dist-upgrade -yqq
echo "Autoremove old Updates"    
	apt-get autoremove -yqq
echo "ethotools fix"
	sudo apt-get install ethtool -yqq && ethtool -K enp0s31f6 tso off gso off
echo "install vainfo"
	sudo apt install vainfo -yqq
echo "install complete"

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Hetzner iGPU / GPU HW-Transcode
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1] Ubuntu 16.04 LTS
[2] Ubuntu 18.04 LTS
[3] Debian 9.6 
[4] iGPU / GPU TEST
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then		
	sed -i '/blacklist i915/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/blacklist i915_bdw/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/^#*/#/g' /etc/default/grub.d/hetzner.cfg
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	sudo usermod -a -G video root
	chmod -R 777 /dev/dri
	docker exec plex apt-get -y update
	docker exec plex apt-get -y install i965-va-driver vainfo
	docker restart plex
	echo "please reboot your server"
	
elif [ "$typed" == "2" ]; then		
	sed -i '/blacklist i915/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/blacklist i915_bdw/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/^#*/#/g' /etc/default/grub
	sudo update-grub
	sudo usermod -a -G video root
	chmod -R 777 /dev/dri
	docker exec plex apt-get -y update
	docker exec plex apt-get -y install i965-va-driver vainfo
	docker restart plex		
	echo "please reboot your server"
	
elif [ "$typed" == "3" ]; then
	sed -i '/blacklist i915/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/blacklist i915_bdw/s/^#*/#/g' /etc/modprobe.d/blacklist-hetzner.conf
	sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/^#*/#/g' /etc/default/grub
	sudo update-grub
	sudo usermod -a -G video root
	chmod -R 777 /dev/dri
	docker exec plex apt-get -y update
	docker exec plex apt-get -y install i965-va-driver vainfo
	docker restart plex
	echo "please reboot your server"	
	
elif [ "$typed" == "4" ]; then

	GPU=$(lspci | grep VGA | cut -d ":" -f3);RAM=$(cardid=$(lspci | grep VGA |cut -d " " -f1);lspci -v -s $cardid | grep " prefetchable"| cut -d "=" -f2)
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo $GPU $RAM	
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	apt-get autoremove vainfo -yqq
	
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
  exit
else
  bash /opt/plexguide/menu/tools/tools.sh
  exit
fi

bash /opt/plexguide/menu/tools/tools.sh
exit	
