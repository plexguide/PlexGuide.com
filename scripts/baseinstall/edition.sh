#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

mkdir -p /var/plexguide/hd 1>/dev/null 2>&1
#hd1=$( cat /var/plexguide/hd/hd1 )

HEIGHT=12
WIDTH=36
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Set Your Mount Paths!"

OPTIONS=(A "GDrive Edition"
         B "HD Multiple Edition (TEST)"
         C "HD Solo Edition     (TEST)"
         D "Mini FAQ"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      file="/var/plexguide/pg.edition"
      if [ -e "$file" ]
      then
         echo "PG Edition: GDrive" > /var/plexguide/pg.edition
      else
         echo "PG Edition: GDrive" > /var/plexguide/pg.edition
         bash /opt/plexguide/scripts/menu.sh
      fi

      exit
      ;;

    B)
      file="/var/plexguide/pg.edition"
      if [ -e "$file" ]
      then
         echo "PG Edition: HD Multiple" > /var/plexguide/pg.edition
      else
         echo "PG Edition: HD Multiple" > /var/plexguide/pg.edition
         #bash /opt/plexguide/menus/localmain.sh
         bash /opt/plexguide/scripts/menu.sh
      fi

      exit
      ;;

    C)
      file="/var/plexguide/pg.edition"
      if [ -e "$file" ]
      then
         echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
      else
         echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
         bash /opt/plexguide/scripts/menu.sh
      fi

      exit
      ;;
    D)
      dialog --title "Quick FAQ" --msgbox "\nYou can pick between using your local drives or Google Drive for your mass media storage collection.\n\nBe aware the LOCAL STORAGE option is not ready and is here for testing/demo purposes until ready" 0 0
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
    Z)
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
esac
bash /opt/plexguide/scripts/baseinstall/edition.sh  