#!/bin/bash
#
# [HT Generator]
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
  dialog --title "PG APP Guard Protection" --msgbox "\nPurpose is to generate username and passwords for APPS without PROTECTION such as Heimdall, RuTorrent & others\n\nYour Password will Be Hashed for Protection!" 0 0

  dialog --title "Create a USERNAME (case senstive)" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "USERNAME: " 8 50 2>/var/plexguide/server.ht.username
  user=$(cat /var/plexguide/server.ht.username)

    dialog --title "Create a PASSWORD (case senstive)" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "PASSWORD: " 8 50 2>/var/plexguide/server.ht.pw
  pw=$(cat /var/plexguide/server.ht.pw)

  if dialog --stdout --title "Username & Password" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\n$user - $pw\n\nCorrect?" 0 0; then
    dialog --title "Path Choice" --msgbox "\nUsername & Password are SET!" 0 0

    ### Builds the Username & Password
    htpasswd -cbs /var/plexguide/server.ht $user $pw 1>/dev/null 2>&1

    ### Password is Hased, Files no Longer Needed
    rm -r /var/plexguide/server.ht.pw 1>/dev/null 2>&1
    rm -r /var/plexguide/server.ht.username 1>/dev/null 2>&1

    #### Rebuild Containers
    bash /opt/plexguide/menus/security/rebuild-st.sh

    dialog --title "PG APP Guard Security" --msgbox "\nContainers without protection are now Protected!" 0 0
    exit

  else
    dialog --title "PG APP Guard Status" --msgbox "\nIndicated Username & Password is NOT CORRECT!\n\nRestarting Process!" 0 0
    bash /opt/plexguide/menus/security/ht.sh
    exit
  fi

esac