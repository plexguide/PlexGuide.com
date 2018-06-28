#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/radarr4k/menus/images.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="@Menu"
keyword2="Radarr4k"
### STARTING LOG ######################################################
echo "INFO - $keyword1: Menu Interface of $keyword2" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

### MAIN SCRIPT #######################################################
export NCURSES_NO_UTF8_ACS=1
HEIGHT=12
WIDTH=48
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Select Your Image for $keyword2"
MENU="Make a Selection Choice:"
OPTIONS=(A "linuxserver/radarr: Recommended"
         B "hotio/suitarr     : Space Saver"
         C "aront/radarr      : MP4 Converter"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            echo "linuxserver/radarr" > /var/plexguide/image.radarr4k 
            echo "" > /var/plexguide/extra.radarr4k
            ;;
        B)
            echo "hotio/suitarr" > /var/plexguide/image.radarr4k
            echo "/Radarr" > /var/plexguide/extra.radarr4k
            ;;
        C)
            echo "aront/radarr" > /var/plexguide/image.radarr4k 
            echo "" > /var/plexguide/extra.radarr4k
            ;;
        D)
            ;;
        Z)
            clear
            exit 0 ;;
esac
## ENDING: DECLARED VARIABLES 

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh