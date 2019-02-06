#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/pggce.sh

question1 () {
gcestarter

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG GCE Deployment                    ⚡ Reference: gce.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Log Into the Account  : $account
2. Build a New Project
3. Set Project ID        : $projectid
4. Set Processor Count   : $processor
5. Set IP Region / Server: $ipaddress - $ipregion
6. Deploy GCE Server     : $serverstatus
7. SSH into the GCE Box
8. Destroy Server
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        ansible-playbook /opt/plexguide/menu/processor/processor.yml  --tags performance
        rebootpro ;;
    2 )
        ansible-playbook /opt/plexguide/roles/menu/processor.yml  --tags ondemand
        rebootpro ;;
    3 )
        ansible-playbook /opt/plexguide/roles/menu/processor.yml  --tags conservative
        rebootpro ;;
    4 )
        echo ""
        cpufreq-info
        echo ""
        read -p '🌍  Done? | Press [ENTER] ' typed < /dev/tty
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
  bash /opt/plexguide/menu/processor/scripts/reboot.sh
}

question1
