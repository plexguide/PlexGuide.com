
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

HEIGHT=10
WIDTH=44
CHOICE_HEIGHT=4
BACKTITLE="WARNING - THIS WILL DELETE YOUR EXISTING DATA ONCE IT'S MOVED TO GDRIVE"
TITLE="Migrate Existing Data"
MENU="Select Media Type:"

OPTIONS=(Z "Exit"
         A "TV"
         B "Movies"
         C "Music"
         D "Ebooks"
         E "Custom"
         F "Stop Import")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

import_media(){
                dialog --title "Select Local $1 Directory" \
                --backtitle "Enter the directory you want migrated to Gdrive." \
                --dselect ~/ 8 45 2>/opt/appdata/plexguide/migrate
                migrate=$(cat /opt/appdata/plexguide/migrate)
                migratesize=$(du -hc $migrate | tail -1 | awk '{print $1}')
                dialog --infobox "The $migratesize of $migrate will be moved to Gdrive.\nRebooting the server will stop the transfer.\nIf you reboot, you can always go back to this menu to try again." 3 45
                /usr/bin/unionfs -o cow,allow_other,nonempty $migrate=RW /mnt/move/$1
                sleep 7

                dialog --infobox "Notice: You can migrate more existing content types if you want.\nMade an error? Just SELECT it again!" 0 0
                sleep 4
}

import_custom(){
                dialog --title "Select Local Directory" \
                --backtitle "Enter the local directory you want migrated to Gdrive." \
                --dselect ~/ 8 45 2>/opt/appdata/plexguide/migrate

                dialog --title "Select Gdrive Directory" \
                --backtitle "Enter the Gdrive Directory You Want The Local Data To Be Migrated To." \
                --dselect /mnt/move 8 45 2>/opt/appdata/plexguide/migrate

                migrate=$(cat /opt/appdata/plexguide/migrate)
                migratesize=$(du -hc $migrate | tail -1 | awk '{print $1}')
                dialog --infobox "The $migratesize of $migrate will be moved to Gdrive.\nRebooting the server will stop the transfer.\nIf you reboot, you can always go back to this menu to try again." 3 45
                /usr/bin/unionfs -o cow,allow_other,nonempty $migrate=RW /mnt/move/$1
                sleep 7

                dialog --infobox "Notice: You can migrate more existing content types if you want!\n\nMade an error? Just SELECT it again!" 0 0
                sleep 4
}
case $CHOICE in
        A)
            import_media tv ;;
        B)
            import_media movies ;;
        C)
            import_media music ;;
        D)
            import_media movies ;;
        E)
            import_media movies ;;
        F)
            import_media movies ;;
        Z)
            clear
            exit 0 ;;
esac

bash /opt/plexguide/menus/notifications/main.sh
