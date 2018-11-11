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
sname="PG Installer: Server ID"
pg_id=$( cat /var/plexguide/pg.id )
pg_id_stored=$( cat /var/plexguide/pg.id.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_id" != "$pg_id_stored" ]; then
  echo "INFO - First Time: Server ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  echo ""
  echo "-----------------------------------------------------"
  echo "SYSTEM MESSAGE: You Must Set a Server ID"
  echo "-----------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  echo ""
  ### Execute Server ID Script
  echo serverid > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

  ### Ensures to Not Rerun
  cat /var/plexguide/pg.id > /var/plexguide/pg.id.stored

  ### Create Recovery ID if it Does Not Exist
  file="/var/plexguide/restore.id"
  if [ ! -e "$file" ]; then
      cat /var/plexguide/server.id > /var/plexguide/restore.id
      echo "INFO - First Time: Restore ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  fi

fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
