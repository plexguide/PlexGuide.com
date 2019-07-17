#!/bin/bash
###############################################################################
# Title: PlexGuide | PGBlitz (  PG System Tweaker )
#
# Author(s): 	Admin9705
# Coder : 	MrDoob - freelance Coder
# URL: 		https://pgblitz.com
# Base :	http://github.pgblitz.com
# GNU: General Public License v3.0E
#
################################################################################
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying  PG System Tweaker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

echo "Updating packages"
apt-get update -yqq 2>&1 >>/dev/null
export DEBIAN_FRONTEND=noninteractive
echo "Upgrading packages"
apt-get upgrade -yqq 2>&1 >>/dev/null
export DEBIAN_FRONTEND=noninteractive
echo "Dist-Upgrading packages"
apt-get dist-upgrade -yqq 2>&1 >>/dev/null
export DEBIAN_FRONTEND=noninteractive
echo "Autoremove old Updates"
apt-get autoremove -yqq 2>&1 >>/dev/null
export DEBIAN_FRONTEND=noninteractive
echo "install complete"

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG System Tweaker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 PG System Tweaker

[1] Network Tweaker ( Debian 9 & Ubuntu 18 only )
[2] Docker Swapness
[3] PGBlitz logrotator
[4] VnStat autoinstaller

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

if [ "$typed" == "1" ]; then
        echo "networktools install | please wait"
        apt-get install ethtool -yqq 2>&1 >>/dev/null
        export DEBIAN_FRONTEND=noninteractive
        echo "networktools installed"
        sleep 2
        network=$(ifconfig | grep -E 'eno1|enp|ens5' | awk '{print $1}' | sed -e 's/://g')
        sleep 2
        echo $network "network detected"
        ethtool -K $network tso off tx off
        sed -i '$a\' /etc/crontab
        sed -i '$a\#################################' /etc/crontab
        sed -i '$a\##	PG Network tweak	  ' /etc/crontab
        sed -i '$a\#################################' /etc/crontab
        sed -i '$a\@reboot ethtool -K '$network' tso off tx off\' /etc/crontab
        sleep 2
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo " ✅ PASSED ! Network Tweak done"
        echo " ✅ PASSED ! crontab line added"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sleep 10

elif [ "$typed" == "2" ]; then
        sudo sysctl vm.swappiness=0
        sudo sysctl vm.overcommit_memory=1
        sed -i '$a\' /etc/sysctl.conf
        sed -i '$a\' /etc/sysctl.conf
        sed -i '$a\#########################################' /etc/sysctl.conf
        sed -i '$a\##	Docker PG Swapness changes	  ' /etc/sysctl.conf
        sed -i '$a\#########################################' /etc/sysctl.conf
        sed -i '$a\vm.swappiness=0\' /etc/sysctl.conf
        sed -i '$a\vm.overcommit_memory=1\' /etc/sysctl.conf
        sleep 2
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo " ✅ PASSED ! Docker swappiness offline"
        echo " ✅ PASSED ! systctl edit"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sleep 10

elif [ "$typed" == "3" ]; then
        username=$(grep "1000" /etc/passwd | cut -d: -f1 | awk '{print $1}')

        sed -i '/#compress/s/^#*//g' /etc/logrotate.conf
        sed -i 's/weekly/daily/g' /etc/logrotate.conf
        sed -i 's/rotate 4/rotate 1/g' /etc/logrotate.conf

        sleep 2

        sed -i '$a\ ' /etc/logrotate.conf
        sed -i '$a\########################################' /etc/logrotate.conf
        sed -i '$a\##    PGBlitz Upload logrotate          ' /etc/logrotate.conf
        sed -i '$a\########################################' /etc/logrotate.conf
        sed -i '$a\ ' /etc/logrotate.conf
        sed -i '$a\/var/plexguide/logs/*.log {' /etc/logrotate.conf
        sed -i '$a\     su '$username' '$username' ' /etc/logrotate.conf
        sed -i '$a\     rotate 7' /etc/logrotate.conf
        sed -i '$a\     daily' /etc/logrotate.conf
        sed -i '$a\     compress' /etc/logrotate.conf
        sed -i '$a\     missingok' /etc/logrotate.conf
        sed -i '$a\     notifempty' /etc/logrotate.conf
        sed -i '$a\     maxage 7' /etc/logrotate.conf
        sed -i '$a\     create 755 '$username' '$username'' /etc/logrotate.conf
        sed -i '$a\}' /etc/logrotate.conf
        sed -i '$a\ ' /etc/logrotate.conf
        sed -i '$a\######################################' /etc/logrotate.conf
        sed -i '$a\##    PGBlitz Upload logrotate        ' /etc/logrotate.conf
        sed -i '$a\######################################' /etc/logrotate.conf
        sleep 2
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo " ✅ PASSED ! PGBlitz logrotate installed"
        echo " ✅ PASSED ! Daily backup from the logs"
        echo " ✅ PASSED ! max age 7 Days "
        echo " ✅ PASSED ! auto delete older logs"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sleep 10

elif [ "$typed" == "4" ]; then
        echo "networktools | vnstat | vnstati install | please wait"
        apt-get install ethtool vnstat vnstati -yqq 2>&1 >>/dev/null
        export DEBIAN_FRONTEND=noninteractive
        echo "networktools | vnstat | vnstati installed"
        sleep 2
        network=$(ifconfig | grep -E 'eno1|enp|ens5' | awk '{print $1}' | sed -e 's/://g')
        sleep 2
        echo $network "network detected"
        sed -i 's/eth0/'$network'/g' /etc/vnstat.conf
        sed -i 's/UnitMode 0/UnitMode 1/g' /etc/vnstat.conf
        sed -i 's/RateUnit 1/RateUnit 0/g' /etc/vnstat.conf
        sed -i 's/Locale "-"/Locale "LC_ALL=en_US.UTF-8"/g' /etc/vnstat.conf
        sleep 2
        /etc/init.d/vnstat restart 2>&1 >>/dev/null
        sleep 2
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo " ✅ PASSED ! vnstat installed"
        echo " ✅ PASSED ! vnstat -l [ live traffic ]"
        echo " ✅ PASSED ! vnstat -d [ daily traffic ]"
        echo " ✅ PASSED ! vnstat -w [ weekly traffic ]"
        echo " ✅ PASSED ! vnstat -m [ month traffic ]"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sleep 10

elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
        exit
else
        bash /opt/plexguide/menu/tools/tools.sh
        exit
fi
bash /opt/plexguide/menu/tools/tools.sh
exit
