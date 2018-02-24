
 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

whiptail --title "Plex Information" --msgbox "Visit http//:$ipv4:32400/web to complete the install. If installing Plex on a REMOTE SERVER, have your Plex Claim Token ready by heading to https://plex.tv/claim. The Claim Token is valid only for 4 minutes! If the claim process does not work, read the plex wiki for the other 3 methods to claim!" 16 66

HEIGHT=4
WIDTH=40
CHOICE_HEIGHT=2
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Select your Plex Preference:"

OPTIONS=(A "Plex Install"
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