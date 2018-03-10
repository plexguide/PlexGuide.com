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
HEIGHT=22
WIDTH=70
CHOICE_HEIGHT=16
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG NCDU Directory Size Menu"
MENU="*** Press q to quit! ***"

OPTIONS=(A "Entire drive - excluding /mnt WARNING Can take a long time!"
         B "Entire drive - excluding /opt WARNING Can take a long time!"
         C "Entire drive - excluding /mnt & /opt"
         D "/opt - WARNING Can take a long time!"
         E "/mnt - WARNING Can take a long time!"
         F "Move"
         G "UnionFS - WARNING Can take a long time!"
         H "NZBGET"
         I "SAB"
         J "Deluge"
         K "RuTorrent"
         L "TorrentVPN"
         M "/home"
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
      ncdu / --exclude=/opt
      ;;

    C)
      clear
      ncdu / --exclude=/mnt --exclude=/opt
      ;;

    D)
        clear
        ncdu /opt
        ;;

    E)
        clear
        ncdu /mnt
        ;;

    F)
      clear
      ncdu /mnt/move
      ;;

    G)
      clear
      ncdu /mnt/unionfs
      ;;

    H)
      clear
      ncdu /mnt/nzbget
      ;;

    I)
        clear
        ncdu /mnt/sab
        ;;

    J)
        clear
        ncdu /mnt/deluge
        ;;

    K)
        clear
        ncdu /mnt/rutorrent
        ;;

     L)
         clear
         ncdu /mnt/torrentvpn
         ;;

      M)
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
