#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

#############
HEIGHT=10
WIDTH=45
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive selection for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "Unencrypted (Recommended)"
         B "Encrypted"
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
            bash /opt/plexguide/menus/pgdrive/main.sh
              echo "RClone - You Chose the Unencrypted Method" > /tmp/pushover
#              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
#              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean &>/dev/null &
              ;;
        B)
            bash /opt/plexguide/menus/pgdrive_en/main.sh
              echo "RClone - You Chose the Encrypted Method" > /tmp/pushover
#              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
#              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags clean-encrypt &>/dev/null &
              ;;
        Z)
            clear
            exit 0 ;;
esac
