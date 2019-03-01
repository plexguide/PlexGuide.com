#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# Menu Interface
setstart() {

emdisplay=$(cat /var/plexguide/emergency.display)
switchcheck=$(cat /var/plexguide/pgui.switch)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Download Path    :  Change the Processing Location
[2] Processor        :  Enhance the CPU Processing Power
[3] WatchTower       :  Auto-Update Application Manager
[4] Change Time      :  Change the Server Time
[5] PG UI            :  $switchcheck | Port 8555 | pgui.domain.com
[6] Emergency Display:  $emdisplay
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
      bash /opt/plexguide/menu/dlpath/dlpath.sh
      setstart;;
    2 )
      bash /opt/plexguide/menu/processor/processor.sh
      setstart ;;
    3 )
      watchtower ;;
    4 )
      dpkg-reconfigure tzdata ;;
    5 )
      echo
      echo "Standby ..."
      echo
      if [[ "$switchcheck" == "On" ]]; then
         echo "Off" > /var/plexguide/pgui.switch
         docker stop pgui
         docker rm pgui
      else echo "On" > /var/plexguide/pgui.switch
        bash /opt/plexguide/menu/pgcloner/solo/pgui.sh
        ansible-playbook /opt/pgui/pgui.yml
      fi
      setstart ;;
    6)
       if [[ "$emdisplay" == "On" ]]; then echo "Off" > /var/plexguide/emergency.display
       else echo "On" > /var/plexguide/emergency.display; fi
       setstart ;;
    z )
      exit ;;
    Z )
      exit ;;
    * )
      setstart ;;
esac

}

setstart
