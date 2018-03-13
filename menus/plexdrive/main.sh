#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
############# User Confirms They Understand
dialog --title "Very Important" --msgbox "\nWhen PlexDrive finishes the initial scan, make sure to reboot the server! If using PD5 and then says 'Opening Cache' - go ahead and reboot the server!" 0 0


############# Menu
HEIGHT=12
WIDTH=45
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PlexDrive for PG"
MENU="Choose one of the following options:"

OPTIONS=(A "PlexDrive4 (Recommended)"
         B "PlexDrive5 "
         C "Remove PlexDrive Tokens"
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
            if dialog --stdout --title "PlexDrive 4 Install" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nDo you want to install PlexDrive4?" 7 50; then
                sudo ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexdrive --skip-tags plexdrive5
                mv /tmp/plexdrive-linux-amd64 plexdrive
                mv plexdrive /usr/bin/
                cd /usr/bin/
                chown root:root /usr/bin/plexdrive
                chmod 755 /usr/bin/plexdrive
                systemctl daemon-reload
                systemctl enable plexdrive.service
                plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive /mnt/plexdrive
            else
              dialog --title "PG Update Status" --msgbox "\nExiting - User Selected No" 0 0
              echo "Type to Restart the Program: sudo plexguide"
              exit 0
            fi
            ;;
        B)
            if dialog --stdout --title "PlexDrive 5 Install" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nDo you want to install PlexDrive5?" 7 50; then
                sudo ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexdrive --skip-tags plexdrive4
                mv /tmp/plexdrive-linux-amd64 plexdrive
                mv plexdrive /usr/bin/
                cd /usr/bin/
                chown root:root /usr/bin/plexdrive
                chmod 755 /usr/bin/plexdrive
                systemctl daemon-reload
                systemctl enable plexdrive.service
                plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --chunk-check-threads=8 --chunk-load-threads=8 --chunk-load-ahead=6 --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive --cache-file=/root/.plexdrive/cache.bolt /mnt/plexdrive
            else
              dialog --title "PG Update Status" --msgbox "\nExiting - User Selected No" 0 0
              echo "Type to Restart the Program: sudo plexguide"
              exit 0
            fi
            ;;
        C)
            rm -r /root/.plexdrive 1>/dev/null 2>&1
            rm -r ~/.plexdrive 1>/dev/null 2>&1
            clear
            echo "Tokens Removed - Try PlexDrive Install Again"
            echo
            read -n 1 -s -r -p "Press any key to continue"
            clear
            bash /opt/plexguide/menus/plexdrive/main.sh ;;
        Z)
            clear
            exit 0 ;;
esac
