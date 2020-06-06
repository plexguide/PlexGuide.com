#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
question1 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Processer Policy Interface      ⚡ Reference: processor.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Works only on Dedicated Servers! (No VPS, ESXI, VMs, and etc)

1. Performance Mode
2. OnDemand Mode
3. Conservative Mode
4. View Processor Policy
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Number | Press [Enter]: ' typed < /dev/tty

case $typed in
    1 )
        ansible-playbook /pg/pgblitz/menu/processor/processor.yml  --tags performance
        rebootpro ;;
    2 )
        ansible-playbook /pg/pgblitz/roles/menu/processor.yml  --tags ondemand
        rebootpro ;;
    3 )
        ansible-playbook /pg/pgblitz/roles/menu/processor.yml  --tags conservative
        rebootpro ;;
    4 )
        echo ""
        cpufreq-info
        echo ""
        read -p '🌍  Done? | Press [Enter] ' typed < /dev/tty
        ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        question1 ;;
esac
}

rebootpro() {
  bash /pg/pgblitz/menu/processor/scripts/reboot.sh
}

question1
