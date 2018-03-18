#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

file="/root/.config/rclone/rclone.conf"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   #ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rclone_un --skip-tags rclone &>/dev/null &
   dialog --infobox "RCLONE:  Installing a Dummy Starter File\n\nOne Time Deal! DummyProofing!            " 0 0
   ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rclone_un --skip-tags rclone 1>/dev/null 2>&1
   sleep 2
fi

#############
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
            bash /opt/plexguide/scripts/docker-no/rclone-un.sh
              echo "RClone - You Chose the Unencrypted Method" > /tmp/pushover
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
              ;;
        B)
            bash /opt/plexguide/scripts/docker-no/rclone-en.sh
              echo "RClone - You Chose the Encrypted Method" > /tmp/pushover
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
              ;;
        Z)
            clear
            exit 0 ;;
esac
