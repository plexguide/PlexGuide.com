 if dialog --stdout --title "Domain Question" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nReady to Setup Your Domain Now?" 7 50; then
        echo "later" > /var/plexguide/server.domain
        clear
        echo "95" | dialog --gauge "Installing: Traefik" 7 50 0
        sleep 2
        dialog --title "First Time Domain Setup" --msgbox "\nSetting Up Your Domain For The First Time" 0 0
        
        dialog --title "Input >> Your Domain" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Domain (Example - plexguide.com)" 8 40 2>/var/plexguide/server.domain
        dom=$(cat /var/plexguide/server.domain)

        dialog --title "Input >> Your E-Mail" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "E-Mail (Example - user@pg.com)" 8 37 2>/var/plexguide/server.email
        email=$(cat /var/plexguide/server.email)

        dialog --infobox "Set Domain is $dom" 3 45
        sleep 2
        dialog --infobox "Set E-Mail is $email" 3 45
        sleep 2
        dialog --infobox "Need to Change? Change via Settings Any Time!" 4 28
        sleep 2
        
        ##### NOTE THAT THIS A ONETIME MENU
        dialog --title "Copy & Paste Note" --msgbox "\nNote: For COPY & PASTE, write this down!\n\nWIN Users - SHIFT + INSERT\nMAC Users - CMD + V" 0 0
        bash /opt/plexguide/menus/traefik/main.sh
      else
        dialog --title "Domain - No" --msgbox "\nSet this up later anytime via settings!" 0 0
        echo "NO-DOMAIN" > /var/plexguide/server.domain
 fi
