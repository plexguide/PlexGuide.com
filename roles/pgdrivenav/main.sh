#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1

#### Recalls from prior menu what user selected
selected=$( cat /var/plexguide/menu.select )

################################################################## UN OR ENCRYPTED
echo 'INFO - @PG Drive Version Select Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=11
WIDTH=50
CHOICE_HEIGHT=3
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w $selected"
MENU="Select a Version:"

OPTIONS=(A "PGDrives: ST2 - Unencrypted"
         B "PGDrives: ST2 - Encrypted (NOT READY)"
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
    echo "unencrypted" > /var/plexguide/pgdrives_format 1>/dev/null 2>&1
    bash /opt/plexguide/roles/pgdrivenav/unencrypted.sh ;;
  B)
    echo "encrypted" > /var/plexguide/pgdrives_format 1>/dev/null 2>&1
    #### Halted, NOT READY
    #  dialog --title "WARNING!" --msgbox "\nPGDrives Encrypted is Not Ready\n\nUse the PLEXDRIVE Traditional Method for Now" 0 0
    ##recommend this forwards to another script/menu when it works
    bash /opt/plexguide/roles/pgdrivenav/encrypted.sh
  exit ;;
########## Deploy End
esac
