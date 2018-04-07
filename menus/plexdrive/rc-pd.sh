 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
HEIGHT=10
WIDTH=28
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PlexDrive - Mounts"
MENU="Make a Selection:"

OPTIONS=(A "PlexDrive"
         B "RClone"
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
            bash /opt/plexguide/menus/plexdrive/main.sh ;;
        B)
            bash /opt/plexguide/menus/rclone/select.sh ;;
        Z)
            clear
            exit 0 ;;
esac