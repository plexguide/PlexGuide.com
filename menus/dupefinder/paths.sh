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

rm -r /var/plexguide/plex.library
rm -r /var/plexguide/plex.library.json
message=""
#dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0

while [ "$word" != "next" ]
do 

message=$( cat /var/plexguide/plex.library )
current=$( cat /tmp/plex.library )





  HEIGHT=10
  WIDTH=43
  CHOICE_HEIGHT=3
  BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
  TITLE="PG Server Security"
  MENU="Your Current Library!\n\n$current $message \n\nKeep Adding More?"
  OPTIONS=(A "Add Another Library"
           B "Restart"
           Z "Finished")
  CHOICE=$(dialog --clear \
                  --backtitle "$BACKTITLE" \
                  --title "$TITLE" \
                  --menu "$MENU" \
                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)
  clear
  case $CHOICE in
          A)
            cat /tmp/plex.library >> /var/plexguide/plex.library
            echo "" >> /var/plexguide/plex.library 
            ;;
          B)
            word="next"
            cat /tmp/plex.library >> /var/plexguide/plex.library
            echo "" >> /var/plexguide/plex.library 
            ;;
          Z)
            clear
            exit 0
            ;;
  esac

#dialog --title "Your Plex Library" --msgbox "$message" 0 0
done

clear
cat /var/plexguide/plex.library

exit

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
        rm -r "$path/plexguide"
      else
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nTHE PATH does not EXIST! Re-Running Menu!" 0 0
        bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
    fi

    ### Ensure Location Get Stored for Variables Role
    echo "$path" > /var/plexguide/server.hd.path

    ##### Symbolic Link
    #path="/mnt/hd2"
    rm -r "/mnt/move" 1>/dev/null 2>&1
    mkdir "$path/move" 1>/dev/null 2>&1
    ln -s "$path/move" /mnt

    #### Rebuild Containers
    dialog --infobox "Rebuilding Folders For: $path" 3 55
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders 1>/dev/null 2>&1

    #### Rebuild Containers
    bash /opt/plexguide/scripts/baseinstall/rebuild.sh

    dialog --title "PG Container Status" --msgbox "\nContainers Rebuilt According to Your Path!\n\nWant to check? Use PORTAINER and check the ENVs of certain containers!" 0 0
    exit

  else
    dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nIs NOT Correct. Re-running HD Menu!" 0 0
    bash /opt/plexguide/scripts/baseinstall/harddrive.sh
    exit
  fi

esac