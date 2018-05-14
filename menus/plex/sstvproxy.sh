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
 ## point to variable file for ipv4 and domain.com
hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ipv4=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1
domain=$( cat /var/plexguide/server.domain ) 1>/dev/null 2>&1

 ### demo ip / comment out when done
 #ipv4=69.69.69.69

display=SSTVProxy
program=sstvproxy
port=8098

dialog --infobox "SSTVProxy is unsupported at this time due to being in beta and the complexity of configuring. You must already have a good understanding of it and how it works to use it!" 5 75
sleep 4

dialog --title "SmoothStreams Username" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Username: Enter your SmoothStreams Username" 8 50 2>/tmp/sstvuser
sstvuser=$(cat /tmp/sstvuser)
dialog --infobox "Username: $sstvuser" 5 80
sleep 3

dialog --title "SmoothStreams Password" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Password: Enter your SmoothStreams Password" 8 50 2>/tmp/sstvpwd
sstvpwd=$(cat /tmp/sstvpwd)
dialog --infobox "Password: $sstvpwd" 5 80
sleep 3

dialog --infobox "Installing SSTVProxy: Please Wait" 3 35
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sstvproxy &>/dev/null &
sleep 4
