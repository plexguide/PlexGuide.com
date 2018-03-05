#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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


## This is to analyse what's taking up space on you drives

# sudo apt install ncdu -y
export NCURSES_NO_UTF8_ACS=1
HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=15
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG NCDU Directory Size Menu"
MENU="*** Press q to quit! ***"

OPTIONS=(A "Entire drive - excluding /mnt"
         B "Entire drive - excluding /mnt & /opt"
         C "/opt - WARNING Can take a long time!"
         D "/mnt - WARNING Can take a long time!"
         E "Move"
         F "UnionFS - WARNING Can take a long time!"
         G "NZBGET"
         H "SAB"
         I "Deluge"
         J "RuTorrent"
         K "TorrentVPN"
         L "/home"
         X "Back to Main Menu"
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
      clear
      ncdu / --exclude=/mnt
      ;;

    B)
      clear
      ncdu / --exclude=/mnt --exclude=/opt
      ;;

    C)
        clear
        ncdu /opt
        ;;

    D)
        clear
        ncdu /mnt
        ;;

    E)
      clear
      ncdu /mnt/move
      ;;

    F)
      clear
      ncdu /mnt/unionfs
      ;;

    G)
      clear
      ncdu /mnt/nzbget
      ;;

    H)
        clear
        ncdu /mnt/sab
        ;;

    I)
        clear
        ncdu /mnt/deluge
        ;;

    J)
        clear
        ncdu /mnt/rutorrent
        ;;

     K)
         clear
         ncdu /mnt/torrentvpn
         ;;

      L)
          clear
          ncdu /home
          ;;

     X)
         clear
         bash /opt/plexguide/menus/main.sh
         ;;

      Z)
      clear
      exit 0
      ;;
esac

### loops until exit
bash /opt/plexguide/menus/info-tshoot/ncdu.sh
