#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

#############
HEIGHT=10
WIDTH=45
CHOICE_HEIGHT=
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PlexDrive for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "RClone Cache - Unencrypted"
         B "RClone - Encrypted (NOT READY)"
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
              echo "RClone Cache Installed" > /tmp/pushover
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean &>/dev/null &
              ;;
        B)
            bash /opt/plexguide/menus/rclone/encache.sh
              echo "RClone Cache Installed" > /tmp/pushover
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean &>/dev/null &
              ;;
        Z)
            clear
            exit 0 ;;
esac
