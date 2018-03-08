
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

display=PLEX
program=plex
port=32400

    dialog --infobox "Pay ATTENTION: Is this Server A REMOTE SERVER (Non-Local)?\nIf You SAY -NO- and it is, you must repeat this process!" 5 50
    sleep 4

    if dialog --stdout --title "PAY ATTENTION!" \
      --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
      --yesno "\nIs this Server a REMOTE SERVER (Non-Local)?" 7 50; then

    dialog --title "PLEX CLAIM INFORMATION" \
    --msgbox "\nVisit http://plex.tv/claim and PRESS the [COPY] Button (do not highlight and copy). You have 5 minutes starting NOW! [PRESS ENTER] when you are READY!" 10 50

    dialog --title "Input >> PLEX CLAIM" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "Visit http://plex.tv/claim - Token?" 8 40 2>/tmp/plextoken
    plextoken=$(cat /tmp/plextoken)
    dialog --infobox "Typed Tag: $token" 3 45
    sleep 4
    clear
    else
        echo "claimedalready" > /tmp/plextoken 1>/dev/null 2>&1
    fi


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
                dialog --infobox "Selected Tag: Latest" 3 38
                sleep 4
                clear
                
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools
            read -n 1 -s -r -p "Press any key to continue "
            ;;

        B)
                dialog --title "Warning - Tag Info" \
                --msgbox "\nVisit http://tags.plexguide.com and COPY and PASTE a TAG version in the dialog box coming up! If you mess this up, you will get a nasty red error in ansible.  You can rerun to fix!" 10 50

                dialog --title "Input >> Tag Version" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Tags Example: 1.12.0.4829-6de959918" 8 40 2>/tmp/plextag
                plexgtag=$(cat /tmp/plextag)
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 4
                clear

            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools
            read -n 1 -s -r -p "Press any key to continue "

            ;;
        Z)
            clear
            exit 0 ;;
esac

dialog --title "Input >> Tag Version" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Tags Example: 1.12.0.4829-6de959918" 8 40 2>/tmp/plextag
plexgtag=$(cat /tmp/plextag)

########## Deploy End
esac 

if dialog --stdout --title "WebToos 3.0" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nDo You Want to Install WebTools 3.0?" 7 50; then
    dialog --infobox "WebTools: Installing - Please Wait (Slow)" 3 48
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags webtools 1>/dev/null 2>&1
else
    dialog --infobox "WebTools: Not Installed" 3 45
    sleep 3
fi
            
dialog --title "FOR REMOTE PLEX SERVERS Users!" \
--msgbox "\nRemember to claim your SERVER @ http(s)://$ipv4:32400. \nGoto Sttings > Remote access > Check Manual > Type Port 32400 > ENABLE. \nMake sure its turn GREEN! DO NOT FORGET or do it now!" 13 50


########## Deploy Start
number=$((1 + RANDOM % 2000))
echo "$number" > /tmp/number_var

if [ "$skip" == "yes" ]; then
    clear
else

    HEIGHT=10
    WIDTH=42
    CHOICE_HEIGHT=5
    BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
    TITLE="Schedule a Backup of --$display --?"

    OPTIONS=(A "Weekly"
             B "Daily"
             Z "None")

    CHOICE=$(dialog --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    case $CHOICE in
            A)
                dialog --infobox "Establishing [Weekly] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            B)
                dialog --infobox "Establishing [Daily] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            Z)
                dialog --infobox "Removing CronJob (If Exists)" 3 34
                echo "$program" > /tmp/program_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nocron 1>/dev/null 2>&1
                --msgbox "\nNo Daily Backups will Occur of -- $display --!" 0 0
                clear ;;
    esac
fi
########## Deploy End

dialog --title "$display - Address Info" \
--msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://plex.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/media.sh

exit