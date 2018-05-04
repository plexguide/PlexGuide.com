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

############################################################################# MINI MENU SELECTION - START
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1
path=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1
deploy=$( cat /var/pg.server.deploy ) 1>/dev/null 2>&1

############################################################################# MINI MENU SELECTION - END

#### Ensure Solo Edition's Path is /mnt
#if [ "$edition" == "PG Edition: HD Solo" ]
#  then
  #### If not /mnt, it will go through this process to change it!
#  if [ "$path" == "/mnt" ] 
#    then
#      clear 1>/dev/null 2>&1
#    else
#      dialog --title "-- NOTE --" --msgbox "\nWe have detected that /mnt IS NOT your default DOWNLOAD PATH for this EDITION.\n\nWe will fix that for you!" 0 0
#      echo "no" > /var/plexguide/server.hd
#      echo "/mnt" > /var/plexguide/server.hd.path
#      bash /opt/plexguide/scripts/baseinstall/rebuild.sh
#  fi
#fi

#### Disable Certain Services #### put a detect move.service file here later
#systemctl stop move 1>/dev/null 2>&1
#systemctl disable move 1>/dev/null 2>&1
#systemctl deamon-reload 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=16
WIDTH=40
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "PG Program Suite"
         B "PG Server Security"
         C "PG HD Setup"
         D "PG Server Information"
         E "PG Troubleshooting Actions"
         F "PG Settings"
         G "PG Update"
         H "PG Edition Switch"
         I "Donation Menu"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            bash /opt/plexguide/menus/programs/main.sh ;;

        B)
            bash /opt/plexguide/menus/security/main.sh ;;

        C)
            #### Solo Drive Edition
            if [ "$edition" == "PG Edition: HD Solo" ]
              then
              dialog --title "-- NOTE --" --msgbox "\nNOT enabled for HD Solo Edition! You only have ONE DRIVE!" 0 0
              bash /opt/plexguide/menus/localmain.sh
              exit
            fi

############ If Not Installed
if [ "$deploy" == "drives" ]
  then
    clear 1>/dev/null 2>&1
  else
file="/usr/bin/mergerfs" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
dialog --infobox "Installing MergerFS!" 7 50
wget "https://github.com/trapexit/mergerfs/releases/download/2.24.2/mergerfs_2.24.2.ubuntu-xenial_amd64.deb" #1>/dev/null 2>&1sudo
apt-get install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y #1>/dev/null 2>&1
git clone https://github.com/trapexit/mergerfs.git #1>/dev/null 2>&1
cd mergerfs
make clean #1>/dev/null 2>&1
make deb #1>/dev/null 2>&1
cd .. 
dpkg -i mergerfs*_amd64.deb #1>/dev/null 2>&1
rm mergerfs*_amd64.deb mergerfs*_amd64.changes mergerfs*.dsc mergerfs*.tar.gz #1>/dev/null 2>&1
fi 
fi

            #### Multiple Editions HD
            bash /opt/plexguide/menus/drives/hds.sh
            ;;
        D)
            bash /opt/plexguide/menus/info-tshoot/infodrives.sh 
            ;;
        E)
            bash /opt/plexguide/menus/info-tshoot/tshoot.sh 
            ;;
        F)
            bash /opt/plexguide/menus/settings/drives.sh
            ;;
        G)
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        H)
            bash /opt/plexguide/scripts/baseinstall/edition.sh ;;
        I)
            bash /opt/plexguide/menus/donate/main.sh ;;
        Z)
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
esac

## repeat menu when exiting
bash /opt/plexguide/menus/localmain.sh