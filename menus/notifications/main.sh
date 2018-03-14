
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
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Notification Manager (Purley Optional)"
MENU="Select Notification Preference(s):"

OPTIONS=(A "Pushover (BETA)  "
         B "Slack (Not Ready)"
         C "Discord (Not Ready)"
         Z "No Notifications")

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
                dialog --title "Input >> Pushover User Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Info 2" 8 40 2>/opt/appdata/plexguide/pushuser
                pushuser=$(cat /opt/appdata/plexguide/pushuser)
                dialog --infobox "Typed Tag: $pushuser" 3 45
                sleep 4

                dialog --title "Input >> Pushover APP Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Info 1" 8 40 2>/opt/appdata/plexguide/pushapp
                pushapp=$(cat /opt/appdata/plexguide/pushapp)
                dialog --infobox "Typed Tag: $pushapp" 3 45
                sleep 4
            ;;
        B)
                dialog --infobox "SLACK IS NOT READY" 7 50
            ;;
        C)
                dialog --infobox "DISCORD IS NOT READY" 7 50
            ;;
        Z)
            clear
            exit 0 ;;
esac 

bash /opt/plexguide/menus/notifications/main.sh