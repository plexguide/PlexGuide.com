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
if [ "$pg_preinstall" == "$pg_preinstall_stored" ]; then
  echo "" 1>/dev/null 2>&1
else
  rm -rf /var/plexguide/update.failed 1>/dev/null 2>&1
  echo "Installing PG Basics" > /var/plexguide/message.phase
  bash /opt/plexguide/menu/interface/install/scripts/message.sh

  echo ""
  echo "------------------------------------------------"
  echo "SYSTEM MESSAGE: PG Install / Upgrade Interface"
  echo "------------------------------------------------"
  echo ""
  echo "CONDITIONS: By Installing PlexGuide, you agree to"
  echo "the terms and use of the GNUv3 License."
  echo ""
  read -p "Agree & Install/Upgrade PlexGuide (y/n)? " -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo ""
    echo "----------------------------------------------"
    echo "SYSTEM MESSAGE: [Y] Key was NOT Selected"
    echo "----------------------------------------------"
    echo ""
    echo "PlexGuide Not Installed/Upgraded! Exiting!"
    echo
    touch /var/plexguide/update.failed
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    echo ""
    bash /opt/plexguide/roles/ending/ending.sh
    echo "WARNING - User Failed To Update PlexGuide" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    exit;
  fi

    echo ""
    yes | apt-get update
    yes | apt-get install software-properties-common
    yes | apt-get install sysstat nmon
    sed -i 's/false/true/g' /etc/default/sysstat
    echo "INFO - Conducted a System Update" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
