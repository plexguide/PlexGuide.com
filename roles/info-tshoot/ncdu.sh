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
echo 'INFO - @NDCU Selection Menu (View Space)' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh

## This is to analyse what's taking up space on you drives

# sudo apt install ncdu -y
export NCURSES_NO_UTF8_ACS=1
HEIGHT=23
WIDTH=70
CHOICE_HEIGHT=17
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG NCDU Directory Size Menu"
MENU="*** Press q to quit! ***"

OPTIONS=(A "Entire drive - excluding /mnt - WARNING Can take a long time!"
         B "Entire drive - excluding /opt - WARNING Can take a long time!"
         C "Entire drive - excluding /mnt & /opt"
         D "/opt - WARNING Can take a long time!"
         E "/opt - excluding Plex & Emby"
         F "/mnt - WARNING Can take a long time!"
         G "/mnt - excluding RClone & PlexDrive mounts"
         H "Move"
         I "UnionFS - WARNING Can take a long time!"
         J "NZBGET"
         K "SAB"
         L "Deluge"
         M "RuTorrent"
         N "TorrentVPN"
         O "/home"
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
        ncdu /opt --exclude=/opt/appdata/plex --exclude=/opt/appdata/embyserver --exclude=/opt/appdata/emby
        ;;

    F)
        clear
        ncdu /mnt
        ;;

    G)
        clear
        ncdu /mnt --exclude=/mnt/gdrive --exclude=/mnt/tdrive --exclude=/mnt/unionfs --exclude=/mnt/plexdrive --exclude=/mnt/encrypt --exclude=/mnt/.gcrypt
        ;;

    H)
      clear
      ncdu /mnt/move
      ;;

    I)
      clear
      ncdu /mnt/unionfs
      ;;

    J)
      clear
      ncdu /mnt/nzbget
      ;;

    K)
        clear
        ncdu /mnt/sab
        ;;

    L)
        clear
        ncdu /mnt/deluge
        ;;

    M)
        clear
        ncdu /mnt/rutorrent
        ;;

     N)
         clear
         ncdu /mnt/torrentvpn
         ;;

      O)
          clear
          ncdu /home
          ;;

#     X)
#         clear
#         bash /opt/plexguide/scripts/test/exit
#         : ${DIALOG_ESC=255}
#         $DIALOG_ESC)
#         exit 0 ;;

      Z)
      clear
      exit 0
      ;;
esac

### loops until exit
bash /opt/plexguide/roles/info-tshoot/ncdu.sh
