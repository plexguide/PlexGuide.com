#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
HEIGHT=12
WIDTH=56
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Assistance Menu"
MENU="Make a Selection Choice:"

OPTIONS=(A "Run PreInstaller Again"
         B "Uninstall Docker, Containers & Run PreInstaller"
         C "Uninstall PlexGuide"
         D "Ansible Bug Test"
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
            dialog --title "Action Confirmed" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!" 0 0
            exit 0 ;;
        B)
            rm -r /etc/docker
            apt-get purge docker-ce
            rm -rf /var/lib/docker
            rm -r /var/plexguide/dep*
            dialog --title "Note" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!" 0 0
            exit 0 ;;
        C)
            rm -r /var/plexguide/dep*
            bash /opt/plexguide/scripts/menus/uninstaller-main.sh ;;
        D)
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags test
            echo ""
            echo "If no RED, Ansible is good; if RED, ansible is bugged!"
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info/main.sh
