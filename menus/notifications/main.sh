
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

file="/var/plexguide/notification.yes"
if [ -e "$file" ]
then
   clear
else
   dialog --infobox "Notice: You can enable PUSH Notifications!\n\nIf NOT READY or DON'T CARE, visit SETTINGS to to put in your INFO later on!" 7 50
   sleep 5
   touch /var/plexguide/notification.yes
fi

HEIGHT=12
WIDTH=44
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Notification Manager (Purley Optional)"
MENU="Select Notification Preference(s):"

OPTIONS=(A "No Notifications"
         B "Pushover"
         C "Discord (Not Ready)"
         D "Slack (Not Ready)"
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
        B)
                dialog --title "Input >> Pushover User Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "USER KEY - WINDOWS USERS: SHIFT+INSERT:" 8 45 2>/opt/appdata/plexguide/pushuser
                pushuser=$(cat /opt/appdata/plexguide/pushuser)
                dialog --infobox "Typed Tag: $pushuser" 3 45
                sleep 4

                dialog --title "Input >> Pushover APP Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "APP KEY - WINDOWS USERS: SHIFT+INSERT:" 8 45 2>/opt/appdata/plexguide/pushapp
                pushapp=$(cat /opt/appdata/plexguide/pushapp)
                dialog --infobox "Typed Tag: $pushapp" 3 45
                sleep 4

                dialog --infobox "Notice: You can configure more notifications; if you want!\n\nMade an error? Just SELECT it again!" 0 0
                sleep 7
            ;;
        D)
                dialog --infobox "SLACK IS NOT READY" 7 50
                sleep 5
            ;;
        C)
                dialog --infobox "DISCORD IS NOT READY" 7 50
                sleep 5
            ;;
        A)
            clear
            exit 0 ;;
        Z)
            clear
            exit 0 ;;
esac 

bash /opt/plexguide/menus/notifications/main.sh