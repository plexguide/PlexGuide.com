
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

dialog --title "Plex Claim Info" \
--msgbox "\nVisit http//:$ipv4:32400/web AFTER to complete the install. If installing Plex on a REMOTE SERVER, have your Plex Claim Token ready by heading to https://plex.tv/claim. The Claim Token is valid only for 4 minutes! If the claim process does not work, read the plex wiki for the other 3 methods to claim!" 12 50

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Select your Plex Preference:"

OPTIONS=(A "Plex Latest"
         B "Plex Custom"
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
            echo "latest" > /tmp/plextag
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
            
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 5
            
            echo "PLEX: http://$ipv4:32400/web"
            echo "For Subdomain https://plex.$domain/web"
            echo "For Domain http://$domain:32400/web"
            echo ""
            read -n 1 -s -r -p "Press any key to continue" ;;
        B)
                
                dialog --title "Input >> Your Domain" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Domain (Example - plexguide.com)" 8 40 2>/tmp/plextag
                dom=$(cat /tmp/plextag)

                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 5

            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
            echo "PLEX: http://$ipv4:32400/web"
            echo "For Subdomain https://plex.$domain/web"
            echo "For Domain http://$domain:32400/web"
            echo ""
            read -n 1 -s -r -p "Press any key to continue" ;;
        Z)
            clear
            exit 0 ;;
esac