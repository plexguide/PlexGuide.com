
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
   mkdir -p /opt/appdata/plexguide
   chmod 755 /opt/appdata/plexguide
   echo "corn" > /opt/appdata/plexguide/pushapp
   echo "corn" > /opt/appdata/plexguide/pushuser
   touch /var/plexguide/notification.yes
fi

HEIGHT=10
WIDTH=44
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Notification Manager (Purley Optional)"
MENU="Select Notification Preference(s):"

OPTIONS=(Z "Exit"
         A "Enable Pushover"
         B "Disable Pushover")

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
        B)
            "fart" > /opt/appdata/plexguide/pushapp
            "butt" > /opt/appdata/plexguide/user

            dialog --infobox "IF this was enabled before, it's now disabled!  Please EXIT!" 0 0
            sleep 6
            exit 0 ;;
        Z)
            clear
            exit 0 ;;
esac 

bash /opt/plexguide/menus/notifications/main.sh