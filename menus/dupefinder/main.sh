#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com

file="/var/plexguide/pgdupes.autodelete"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "ON" > /var/plexguide/pgdupes.autodelete
    echo "true" > /var/plexguide/pgdupes.autodelete.json
    exit
fi

HEIGHT=11
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="DupeFinder"
MENU="Make a Selection:"

OPTIONS=(A "DupeFinder Install/Config"
         B "AutoDelete On/Off - Currently: $stat"
         C "View Your Current Library"
         Z "Exit")

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
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dupefinder 1>/dev/null 2>&1
            ;;
        B)

########################### START
                HEIGHT=10
                WIDTH=40
                CHOICE_HEIGHT=3
                BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
                TITLE="Autodelete"
                MENU="Make a Selection:"

                OPTIONS=(A "AutoDelete: On (Default)"
                         B "AutoDelete: Off"
                         C "Mini FAQ")

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
                            echo "ON" > /var/plexguide/pgdupes.autodelete
                            echo "true" > /var/plexguide/pgdupes.autodelete.json
                            dialog --title "Your Stated Plex Library" --msgbox "\n$display" 0 0
                            ;;
                        B)
                            echo "OFF" > /var/plexguide/pgdupes.autodelete
                            echo "false" > /var/plexguide/pgdupes.autodelete2.json
                            bash /opt/plexguide/menus/dupefinder/paths.sh
                            touch /var/plexguide/pgdupes.status 1>/dev/null 2>&1
                            ;;
                        C)
                            display="$(cat /var/plexguide/plex.library)"
                            dialog --title "--- AutoDelete Info ---" --msgbox "\nBy Default, this is ON. The title speaks for itself.\n\nIf you leave AutoDelete On, it will make the best choice for you. Ideal if you DO NOT want to choose between 700 items.  For those obessed with making a decision, you can turn it OFF!." 0 0
                            bash /opt/plexguide/menus/dupefinder/main.sh
                            ;;
                        Z)
                            clear
                            exit 0 ;;
                esac

######################## END
        C)
            display="$(cat /var/plexguide/plex.library)"
            dialog --title "Your Stated Plex Library" --msgbox "\n$display" 0 0
            ;;

        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/dupefinder/main.sh
