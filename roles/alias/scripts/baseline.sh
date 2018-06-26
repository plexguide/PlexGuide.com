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
# Purpose: Install $keyword1 Commands for Baseline Install
# Execution: bash /opt/plexguide/roles/alias/scripts/baseline.sh
#
#################################################################################
$keyword1=Alias

echo "INFO - Baseline Install: Start Execution of $keyword1 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

pg_alias=$( cat /var/plexguide/pg.alias )
pg_alias_stored=$( cat /var/plexguide/pg.alias.stored )

if [ "$pg_alias" == "$pg_alias_stored" ]
    then
      echo "65" | dialog --gauge "$keyword1 File Is Already Installed" 7 50 0
      echo "INFO - Baseline Install: $keyword1 is Already Installed" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      sleep 2
    else 
      echo "65" | dialog --gauge "Installing: $keyword1 File" 7 50 0
      echo "INFO - Baseline Install: $keyword1 is Installing" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      sleep 2
      clear
      ansible-playbook /opt/plexguide/pg.yml --tags alias
      cat /var/plexguide/pg.alias > /var/plexguide/pg.alias.stored
      sleep 2
fi 

echo "INFO - Baseline Install: Exiting $keyword1 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
