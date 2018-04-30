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
  dialog --title "SET RADARR PATH [ EXAMPLE: /unionfs/movies ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Full Path: " 8 52 2>/tmp/pgtrak.radarr
  path=$(cat /tmp/pgtrak.radarr)

  if dialog --stdout --title "PG Path Builder" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nPATH: $path\n\nCorrect?" 0 0; then
    dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nTracking!" 0 0
    
    ##### If BONEHEAD forgot to add a / in the beginning, we fix for them
    initial="$(echo $path | head -c 1)"
    if [ "$initial" != "/" ]
      then
            pathe="$path"
            path="/$path"
            dialog --title "PG Error Checking" --msgbox "\nForgot to add a FORWARD SLASH in the beginning!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
            echo "$path" > /tmp/plexguide/pgtrak.radarr
      fi
  
    ##### If BONEHEAD added a / at the end, we fix for them  
    initial="${path: -1}"
    if [ "$initial" == "/" ]
      then
            pathe="$path"
            path=${path::-1} 
            dialog --title "PG Error Checking" --msgbox "\nADDED a FORWARD SLASH to the END! Not Needed!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
            echo "$path" > /tmp/plexguide/pgtrak.radarr
      fi

    ##### READ / WRITE CHECK
    mkdir "/mnt$path/plexguide"
    
    file="/mnt$path/plexguide"
    if [ -e "$file" ]
      then
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nThe RADARR Path is Set!" 0 0
        rm -r "/mnt$path/plexguide"
      else
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nTHE PATH does not EXIST! Exiting!" 0 0
        bash /opt/plexguide/menus/pgtrak/main.sh
        exit
    fi

    ### Ensure Location Get Stored for Variables Role
    echo "$path" > /var/plexguide/pgtrak.radarr

  fi

esac