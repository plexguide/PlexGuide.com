#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

######################################################## Declare Variables
sname="PG Installer: Pre-Install Tasks"
pg_preinstall=$( cat /var/plexguide/pg.preinstall )
pg_preinstall_stored=$( cat /var/plexguide/pg.preinstall.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script

### Bypasses Upgrade Quesiton If a New Install
file="/var/plexguide/ask.yes"
if [ -e "$file" ]; then

      if [ "$pg_preinstall" == "$pg_preinstall_stored" ]; then
            echo "" 1>/dev/null 2>&1
          else
            rm -r /var/plexguide/update.failed 1>/dev/null 2>&1
            dialog --infobox "Installing | Upgrading PreInstall Basics" 3 45
            sleep 2
            clear

              if dialog --stdout --title "System Update" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nDo You Agree to Install/Update PlexGuide?" 7 50; then
                clear
              else
                clear
                dialog --title "PG Update Status" --msgbox "\nUser Failed To Agree!\n\nWARNING: Executing any Portions of PG may result with instability!" 0 0
                echo "WARNING - User Failed To Update PlexGuide" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                touch /var/plexguide/update.failed
                exit 0
              fi

        fi

else
  echo "" 1>/dev/null 2>&1
  exit
fi

      yes | apt-get update
      yes | apt-get install software-properties-common
      yes | apt-get install sysstat nmon
      sed -i 's/false/true/g' /etc/default/sysstat
      echo "INFO - Conducted a System Update" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
