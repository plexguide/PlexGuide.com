#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

############################################################################# MINI MENU SELECTION - START
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1
path=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1
deploy=$( cat /var/plexguide/pg.server.deploy ) 1>/dev/null 2>&1

############################################################################# MINI MENU SELECTION - END
dialog --title "-- Solo Deployment --" --msgbox "\nWe have detected that you are setting up or establishing the Multi-HD Deployment!\n\nClick OK to Continue!" 0 0

  #### Disable Certain Services #### put a detect move.service file here later
  systemctl stop move 1>/dev/null 2>&1
  systemctl stop unionfs 1>/dev/null 2>&1
  systemctl disable move 1>/dev/null 2>&1
  systemctl disable unionfs 1>/dev/null 2>&1
  systemctl deamon-reload 1>/dev/null 2>&1

echo "drives" > /var/plexguide/pg.server.deploy
fi