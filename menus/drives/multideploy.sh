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

############################################################################# MINI MENU SELECTION - START
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1
path=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1
deploy=$( cat /var/plexguide/pg.server.deploy ) 1>/dev/null 2>&1

file="/usr/bin/mergerfs" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else

dialog --infobox "Installing MergerFS!" 0 0
wget "https://github.com/trapexit/mergerfs/releases/download/2.24.2/mergerfs_2.24.2.ubuntu-xenial_amd64.deb" 1>/dev/null 2>&1
apt-get install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y 1>/dev/null 2>&1
git clone https://github.com/trapexit/mergerfs.git 1>/dev/null 2>&1
cd mergerfs
make clean 1>/dev/null 2>&1
make deb 1>/dev/null 2>&1
cd .. 
dpkg -i mergerfs*_amd64.deb 1>/dev/null 2>&1
rm mergerfs*_amd64.deb mergerfs*_amd64.changes mergerfs*.dsc mergerfs*.tar.gz 1>/dev/null 2>&1
fi 

if [ "$deploy" == "drives" ]
  then
    clear 1>/dev/null 2>&1
  else
############################################################################# MINI MENU SELECTION - END
dialog --title "-- Solo Deployment --" --msgbox "\nWe have detected that you are setting up or establishing the Multi-HD Deployment!\n\nClick OK to Continue!" 0 0

  #### Disable Certain Services #### put a detect move.service file here later
  systemctl stop move 1>/dev/null 2>&1
  systemctl stop unionfs 1>/dev/null 2>&1
  systemctl disable move 1>/dev/null 2>&1
  systemctl disable unionfs 1>/dev/null 2>&1
  systemctl deamon-reload 1>/dev/null 2>&1

echo "drives" > /var/plexguide/pg.server.deploy
fi