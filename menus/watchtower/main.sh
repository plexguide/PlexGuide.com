
#!/bin/bash
export NCURSES_NO_UTF8_ACS=1


file="/var/plexguide/watchtower.yes"
if [ -e "$file" ]
then
   clear
else
   dialog --title "WatchTower Status" --msgbox "\nNotice: WatchTower enable your Containers to Auto-Update!\n\nPROS: You containers will always be up-to-date.\n\nCONS: If something is wrong with the newest continer, you'll have issues; rare but happens.\n\nNOTE: Typically recommend Plex & Emby to be updated manually. Any automatic update of images can be bugged!" 14 62
fi

HEIGHT=12
WIDTH=52
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="WatchTower Manager"
MENU="Select Notification Preference(s):"

OPTIONS=(A "Update All Containers - Except Plex & Emby"
         B "Update All Containers"
         C "Never Update Containers - Manually Update"
         D "Mini FAQ - WatchTower"
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
            if dialog --stdout --title "WatchTower Question" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nYou Want to --Update All Containers except Plex & Emby?" 7 34; then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower --skip-tags=watchall &>/dev/null &
              dialog --infobox "Notice: Your containers will Auto-Update except PLEX & Emby!\n\nMade an error? Just SELECT it again!" 0 0
              echo "[All Except P&E]" > /var/plexguide/watchtower.yes
              sleep 9
              exit 0
            else
              clear
              dialog --title "WatchTower Status" --msgbox "\nUser Failed to Select Yes, Going Back to the Main Menu!" 0 0
              bash /opt/plexguide/menus/watchtower/main.sh
              exit 0
            fi
            ;;
        B)
            if dialog --stdout --title "WatchTower Question" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nYou Want to have all Your Containers Auto-Update?" 7 34; then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower --skip-tags=plexemby &>/dev/null &
              dialog --infobox "Notice: All Your containers will Auto-Update!\n\nMade an error? Just SELECT it again!" 0 0
              echo "[All Containers]" > /var/plexguide/watchtower.yes
              sleep 9
              exit 0
            else
              clear
              dialog --title "WatchTower Status" --msgbox "\nUser Failed to Select Yes, Going Back to the Main Menu!" 0 0
              bash /opt/plexguide/menus/watchtower/main.sh
              exit 0
            fi
            ;;
        C)
            if dialog --stdout --title "WatchTower Questions" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nDo You Want to Disable and/or Remove WatchTower?" 7 34; then
              docker stop watchtower 1>/dev/null 2>&1
              docker rm watchtower 1>/dev/null 2>&1
              dialog --infobox "Notice: WatchTower is not enabled or has been removed!\n\nUpdate manually by rerunning your targeted Application for the newest update!" 0 0
              echo "[Disabled Updates]" > /var/plexguide/watchtower.yes
              sleep 9
              exit 0
            else
              clear
              dialog --title "WatchTower Status" --msgbox "\nUser Failed to Select Yes, Going Back to the Main Menu!" 0 0
              bash /opt/plexguide/menus/watchtower/main.sh
              exit 0
            fi
              ;;
        D)
              dialog --title "WatchTower Status" --msgbox "\nNotice: WatchTower allows your Containers to Auto-Update!\n\nPROS: Your containers will always be up-to-date.\n\nCONS: If something is wrong with the newest continer, you'll have issues; rare but happens.\n\nNOTE: Typically recommend Plex & Emby to be updated manually for stability purposes!" 0 0
              ;;
        Z)
            file="/var/plexguide/watchtower.yes"
            if [ -e "$file" ]
            then
               exit 0
            else
               dialog --title "Dummy Proof Alert!" --msgbox "\nFor the first time, you must select a status! REDO!" 0 0
            fi
            ;;
esac



bash /opt/plexguide/menus/watchtower/main.sh
