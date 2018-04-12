#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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

if [ "$deploy" == "drive" ]
  then
    clear 1>/dev/null 2>&1
  else
############################################################################# MINI MENU SELECTION - END

  #Ensure Solo Edition's Path is /mnt
  if [ "$edition" == "PG Edition: HD Solo" ]
    then
    dialog --title "-- Solo Deployment --" --msgbox "\nWe have detected that you are setting up or establishing the Solo HD Deployment!\n\nClick OK to Continue!" 0 0

    #### If not /mnt, it will go through this process to change it!
    if [ "$path" == "/mnt" ] 
      then
        clear 1>/dev/null 2>&1
      else
        dialog --title "-- NOTE --" --msgbox "\nWe have detected that /mnt IS NOT your default DOWNLOAD PATH for this EDITION.\n\nWe will fix that for you!" 0 0
        echo "no" > /var/plexguide/server.hd
        echo "/mnt" > /var/plexguide/server.hd.path
        bash /opt/plexguide/scripts/baseinstall/rebuild.sh
    fi
  
  fi

  #### Disable Certain Services #### put a detect move.service file here later
  systemctl stop move 1>/dev/null 2>&1
  systemctl stop unionfs 1>/dev/null 2>&1
  systemctl disable move 1>/dev/null 2>&1
  systemctl disable unionfs 1>/dev/null 2>&1
  systemctl deamon-reload 1>/dev/null 2>&1

  chmod 775 /mnt/unionfs
  chmod 775 /mnt/move
  chown 1000:1000 /mnt/unionfs
  chown 1000:1000 /mnt/move
  ##### Creates a  Symbolic Link
  ln -s "/mnt/move/" "/mnt/unionfs" 1>/dev/null 2>&1
echo "drive" > /var/plexguide/pg.server.deploy
fi