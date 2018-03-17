
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

file="/var/plexguide/watchtower.yes"
if [ -e "$file" ]
then
   clear
else
   dialog --infobox "Notice: You can enable PUSH Notifications!\n\nIf NOT READY or DON'T CARE, visit SETTINGS to to put in your INFO later on!" 7 50
   sleep 6
   touch /var/plexguide/watchtower.yes
fi

HEIGHT=10
WIDTH=52
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="WatchTower Manager"
MENU="Select Notification Preference(s):"

OPTIONS=(A "Update All Containers - Except Plex & Emby"
         B "Update All Containers"
         C "Never Update Containers (Manually Updating")

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
            if dialog --stdout --title "System Update" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nDo You Agree to Install/Update PlexGuide?" 7 50; then
              clear
            else
              clear
              dialog --title "PG Update Status" --msgbox "\nUser Failed To Agree! You can view the program, but doing anything will mess things up!" 0 0
              echo "Type to Restart the Program: sudo plexguide"
              exit 0
            fi

                dialog --infobox "Notice: You can configure more notifications; if you want!\n\nMade an error? Just SELECT it again!" 0 0
                sleep 7
            ;;
        B)
            "fart" > /opt/appdata/plexguide/pushapp
            "butt" > /opt/appdata/plexguide/user
            dialog --infobox "IF this was enabled before, it's now disabled!  Please EXIT!" 0 0
            sleep 6
            ;;
        Z)
            clear
            exit 0 
            ;;
esac 

bash /opt/plexguide/menus/watchtower/main.sh