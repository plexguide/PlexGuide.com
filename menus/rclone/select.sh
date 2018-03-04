#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

HEIGHT=10
WIDTH=45
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PlexDrive for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "RClone - Unencrypted (Recommended)"
         B "RClone - Encrypted"
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
            bash /opt/plexguide/scripts/docker-no/rclone-un.sh ;;
        B)
            bash /opt/plexguide/scripts/docker-no/rclone-en.sh ;;
        Z)
            clear
            exit 0 ;;
esac
