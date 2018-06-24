#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

#############
HEIGHT=10
WIDTH=60
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="RClone Cache for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "RClone Cache - Unencrypted"
         B "RClone Cache - Encrypted (NOT READY)"
         C "Use if switching from or to Cache method"
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
            bash /opt/plexguide/menus/rclone/uncache.sh
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean &>/dev/null &
              ;;
        B)
            bash /opt/plexguide/menus/rclone/encache.sh
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean &>/dev/null &
              ;;
        C)
            bash /opt/plexguide/menus/rclone/switch.sh
            ;;
        Z)
            clear
            exit 0 ;;
esac
