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
######## This is a ONE TIME MENU
export NCURSES_NO_UTF8_ACS=1

### PUT IF SETUP ALREADY, EXIT

HEIGHT=11
WIDTH=35
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice - Visit Again In Settings!"

OPTIONS=(A "YES: A Second HD Will Be Used! It's READY!"
         B "YES: A Second HD Will Be Used! It's NOT READY"
         C "NO:  Do Not Have a SECOND HD! Do NOT ASK AGAIN!"
         D "MINI FAQ: Why this Question?")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0
      echo "yes" > /var/plexguide/server.hd

      dialog --title "Input FULL PATH [ EX: /hd2/media or /hd2 ]" \
      --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
      --inputbox "Full Path: " 8 50 2>/var/plexguide/server.hd.path
      path=$(cat /var/plexguide/server.hd.path)

      if dialog --stdout --title "Path Check" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nPATH: $path - Correct?" 0 0; then
        dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nIs Set! Rebuilding Containers!" 0 0
        
        ##### If user forgot to add a / in the beginning, we fix for them
        initial="$(echo $path | head -c 1)"
        echo "$initial"
        if [ "$initial" != "/" ]
          then
                pathe="$path"
                path="/$path"
                dialog --title "PG Error Checking" --msgbox "\nForgot to add a FORWARD SLASH in the beginning!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
                echo "$path" > /var/plexguide/server.hd.path
          fi
        exit

        #### Rebuild thing
        dialog --title "Path Choice" --msgbox "\nContainers Rebuilt!" 0 0



      else
        dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nIs Not Recorrect. Re-running HD Menu!" 0 0
        bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
      fi

      ;;
    B)
      dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, but not ready!\n\nWhen your ready, visit SETTINGS for setup ANYTIME!" 0 0
      echo "nr" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
            exit
      ;;
    C)
      dialog --title "HD Selection" --msgbox "\nYou Selected: NO 2ND Harddrive for SETUP!\n\nNeed to Make Changes? Visit SETTINGS and change ANYTIME!" 0 0
      echo "no" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
      exit
      ;;
    D)
      dialog --title "NOT READY" --msgbox "\nWill Update the Information" 0 0
      exit
    ;;
esac

file="/opt/appdata/$app"
if [ -e "$file" ]
    then

        if dialog --stdout --title "Backup User Confirmation" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nDo you want to BACKOUT & EXIT from making the Backup -- $app -- ?" 0 0; then
            dialog --title "PG Backup Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
            sudo bash /opt/plexguide/menus/backup-restore/backup.sh
            exit 0
        else
            clear
        fi
    else
        dialog --title "PG Backup Status" --msgbox "\nExiting! You have no LOCAL data -- $app -- to backup to GDrive!" 0 0
        sudo bash /opt/plexguide/menus/backup-restore/backup.sh
        exit 0
fi


exit
