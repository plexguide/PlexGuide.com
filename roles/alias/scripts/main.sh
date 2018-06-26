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
# Purpose: Part of the Baseline Script & Install Alias Commands
#
#################################################################################
pg_alias=$( cat /var/plexguide/pg.alias )
pg_alias_stored=$( cat /var/plexguide/pg.alias.stored )

if [ "$pg_alias" == "$pg_alias_stored" ]
    then
      echo "65" | dialog --gauge "Alias File Is Already Installed" 7 50 0
      sleep 2
    else 
      echo "65" | dialog --gauge "Installing: Alias File" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags alias
      cat /var/plexguide/pg.alias > /var/plexguide/pg.alias.stored
      sleep 2
fi 