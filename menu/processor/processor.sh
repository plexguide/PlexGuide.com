#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
pro1() {
  ansible-playbook /opt/plexguide/menu/processor/processor.yml  --tags performance
  rebootpro
}
pro2() {
  ansible-playbook /opt/plexguide/roles/menu/processor.yml  --tags ondemand
  rebootpro
}
pro3() {
  ansible-playbook /opt/plexguide/roles/menu/processor.yml  --tags conservative
  rebootpro
}
pro4() {
  echo ""
  cpufreq-info
  echo ""
}
rebootpro() {
  bash /opt/plexguide/menu/processor/scripts/reboot.sh
}
exit() {
  exit
}

question1 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Processer Policy Interface       ⚡ Reference: processor.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Performance Mode
2. OnDemand Mode
3. Conservative Mode
4. View Processor Policy
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        pro1 ;;
    2 )
        pro2 ;;
    3 )
        pro3 ;;
    4 )
        pro4 ;;
    z )
        exit 0 ;;
    * )
        question1 ;;
esac
}

question1
