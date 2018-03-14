#!/bin/bash
#
# [PlexGuide Curl Install]
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

sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get full-upgrade -y
sudo apt-get install git -y && sudo apt-get install whiptail -y && sudo apt-get install dialog -y
sudo rm -r /opt/plexguide
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/sc*/ins*
clear
echo "To deploy this Script anytime, type: plexguide"
echo ""
