#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# Menu Interface
setstart () {

swithcheck=$(cat /var/plexguide/pgui.switch)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Download Path:  Change the Processing Location
[2] Processor    :  Enhance the CPU Processing Power
[3] WatchTower   :  Auto-Update Application Manager
[4] Change Time  :  Change the Server Time
[5] PG UI        :  $switchcheck
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
      if [[ "$switchcheck" == "On" ]]; then
         echo "Off" > /var/plexguide/pgui.switch
      else echo "On" > /var/plexguide/pgui.switch; fi
      setstart ;;
    z )
      exit ;;
    Z )
      exit ;;
    * )
      setstart ;;
}
