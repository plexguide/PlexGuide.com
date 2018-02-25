#!/bin/bash

############# User Confirms They Understand
dialog --title "Very Important" --msgbox "When PlexDrive finishes the scan, make sure to reboot! If using PD5 and it says - Opening Cache - go ahead and reboot!" 0 0


############# Menu
HEIGHT=12
WIDTH=45
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PlexDrive for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "PlexDrive4 (Recommended)"
         B "PlexDrive5 "
         C "Remove PlexDrive Tokens"
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
            rm -r /opt/appdata/plexguide/pd5 1>/dev/null 2>&1
            touch /opt/appdata/plexguide/pd4 1>/dev/null 2>&1
            bash /opt/plexguide/scripts/docker-no/plexdrive4.sh ;;
        B)
            rm -r /opt/appdata/plexguide/pd4 1>/dev/null 2>&1
            touch /opt/appdata/plexguide/pd5 1>/dev/null 2>&1
            bash /opt/plexguide/scripts/docker-no/plexdrive.sh ;;
        C)
            rm -r /root/.plexdrive 1>/dev/null 2>&1
            rm -r ~/.plexdrive 1>/dev/null 2>&1
            clear
            echo "Tokens Removed - Try PlexDrive Install Again"
            echo
            read -n 1 -s -r -p "Press any key to continue"
            clear
            bash /opt/plexguide/menus/plexdrive/main.sh ;;
        Z)
            clear
            exit 0 ;;
esac
