 if dialog --stdout --title "Domain Question" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nIs Your Domain Ready to Set Up Now?" 7 50; then
        
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
        
      else
        dialog --title "Domain - No" --msgbox "\nYou can set this up later!" 0 0
        echo "later" > /var/plexguide/server.domain
 fi
