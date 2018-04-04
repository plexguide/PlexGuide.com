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
  dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0
  echo "yes" > /var/plexguide/server.hd

  dialog --title "SET FULL PATH [ EXAMPLE: /hd2/media or /hd2 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Full Path: " 8 50 2>/var/plexguide/server.hd.path
  path=$(cat /var/plexguide/server.hd.path)

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
            echo "$path" > /var/plexguide/server.hd.path
      fi
  
    ##### If BONEHEAD added a / at the end, we fix for them  
    initial="${path: -1}"
    if [ "$initial" == "/" ]
      then
            pathe="$path"
            path=${path::-1} 
            dialog --title "PG Error Checking" --msgbox "\nADDED a FORWARD SLASH to the END! Not Needed!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
            echo "$path" > /var/plexguide/server.hd.path
      fi

    ##### READ / WRITE CHECK
    mkdir "$path/plexguide"
    
    file="$path/plexguide"
    if [ -e "$file" ]
      then
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nThe PATH exists! We are going to CHMOD & CHOWN the path for you!" 0 0
        chown 1000:1000 "$path"
        chmod 0775 "$path"
      else
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nTHE PATH does not EXIST! Re-Running Menu!" 0 0
        bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
    fi

    #### Rebuild t
    dialog --title "Very Important" --msgbox "\nWe must rebuild each container occardingly! Please Be Patient!" 0 0
    docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running
    sed -i -e "/traefik/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/watchtower/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/plex/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/portainer/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/traefik/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/ombi/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/netdata/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/organizr/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/muximux/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/heimdall/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
    sed -i -e "/support/d" /opt/appdata/plexguide/running    1>/dev/null 2>&1
    while read p; do
    echo $p > /tmp/program_var
    app=$( cat /tmp/program_var )
    dialog --infobox "Reconstructing Your Container: $app" 3 50
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags "$app" --skip-tags webtools 1>/dev/null 2>&1
    #read -n 1 -s -r -p "Press any key to continue "
    done </opt/appdata/plexguide/running

    dialog --title "Path Choice" --msgbox "\nContainers Rebuilt!" 0 0
    exit

  else
    dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nIs NOT Correct. Re-running HD Menu!" 0 0
    bash /opt/plexguide/scripts/baseinstall/harddrive.sh
    exit
  fi

esac