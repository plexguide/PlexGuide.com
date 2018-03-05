#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
HEIGHT=11
WIDTH=56
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Assistance Menu"
MENU="Make a Selection Choice:"

OPTIONS=(A "Run PreInstaller Again"
         B "Uninstall Docker, Containers & Run PreInstaller"
         C "Uninstall PlexGuide"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
# ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags var
clear
case $CHOICE in
        A)
            rm -r /var/plexguide/dep* 
            ## dialog message
            exit 0 ;;
        B)
            rm -r /etc/docker
            apt-get purge docker-ce
            rm -rf /var/lib/docker
            rm -r /var/plexguide/dep*
            ## dialog message
            exit 0 ;;
        C)
            rm -r /var/plexguide/dep* 
            bash /opt/plexguide/scripts/menus/uninstaller-main.sh ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info/main.sh