
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

cat /var/plexguide/notification.yes
### if notifcation = yes exit for beginning load up

### put a skip if accessing via normal menu
dialog --infobox "Notice: You can enable PUSH Notifications!\n\nIf NOT READY, visit SETTINGS to to put in your INFO later on!" 7 50
sleep 5

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Select your Plex Preference:"

OPTIONS=(A "Pushover (BETA)  "
         B "Slack (Not Ready)"
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
                dialog --title "Input >> Push Over 1" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Info 1" 8 40 2>/opt/appdata/plexguide/pushover1
                plexgtag=$(cat /tmp/plextag)
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 4
                dialog --title "Input >> Push Over 2" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Info 2" 8 40 2>/opt/appdata/plexguide/pushover2
                plexgtag=$(cat /tmp/plextag)
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 4
            ;;

        B)
            #bash .. /script
            #ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools 1>/dev/null 2>&1
            #read -n 1 -s -r -p "Press any key to continue "
            ;;
        Z)
            clear
            exit 0 ;;
esac 


### put a repeat line, void if this is a first time
