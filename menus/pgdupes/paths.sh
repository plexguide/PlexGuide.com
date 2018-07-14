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
dialog --title "--- NOTE ---" --msgbox "\nFirst time here and not read the Wiki? Visit:\n\nlibrary.plexguide.com" 0 0

rm -r /tmp/plex.library
rm -r /tmp/plex.library.json
rm -r /var/plexguide/plex.library
rm -r /var/plexguide/plex.library.json
message=""
#dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0

while [ "$word" != "next" ]
do 

  dialog --title "Type in your Plex Libraries Exactly as Listed" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Library Title: " 8 50 2>/tmp/plex.library
  message=$( cat /var/plexguide/plex.library )
  current=$( cat /tmp/plex.library )

############# START
    HEIGHT=11
    WIDTH=43
    CHOICE_HEIGHT=2
    BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
    TITLE="Library Type"
    MENU="\nWhat Kind of Library is This? (Important)"
    OPTIONS=(A "TV Library"
             B "Movie Library")
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
              number="2"
              ;;
            B)
              number="1"
              ;;
    esac
############# END


  HEIGHT=15
  WIDTH=50
  CHOICE_HEIGHT=3
  BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
  TITLE="Your Current Library"
  MENU="\n$current $message \n\nKeep Adding More?"
  OPTIONS=(A "Add Another Library"
           B "Clear & Start Over"
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
            ### Display
            cat /tmp/plex.library >> /var/plexguide/plex.library
            echo "" >> /var/plexguide/plex.library
            ### File
            build="$(cat /tmp/plex.library)"
            build="     \"$build\": $number,"
            echo "$build" > /tmp/plex.library.json
            cat /tmp/plex.library.json >> /var/plexguide/plex.library.json
            ;;
          B)
            rm -r /tmp/plex.library
            rm -r /var/plexguide/plex.library
            rm -r /var/plexguide/plex.library.json
            message=""
            ;;
          Z)
            word="next"
            cat /tmp/plex.library >> /var/plexguide/plex.library
            echo "" >> /var/plexguide/plex.library 
            ### File
            build="$(cat /tmp/plex.library)"
            build="     \"$build\": $number"
            echo "$build" > /tmp/plex.library.json
            cat /tmp/plex.library.json >> /var/plexguide/plex.library.json
            chown 1000:1000 /var/plexguide/plex.library.json 1>/dev/null 2>&1
            ;;
  esac

### While Loop Done
done

display="$(cat /var/plexguide/plex.library)"
dialog --title "Your Stated Plex Library" --msgbox "\n$display" 0 0
dialog --title "--- NOTE ---" --msgbox "\nIf your library changes; make sure to update this again!" 0 0