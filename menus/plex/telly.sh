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

display=Telly
program=telly
port=6077

dialog --infobox "Telly is unsupported at this time due to being in beta and the complexity of configuring. You must already have a good understanding of it and how it works to use it!" 5 75
sleep 4

dialog --title "Telly Playlist File" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Playlist path. Either local or URL" 8 50 2>/tmp/tellyplaylist
tellyplaylist=$(cat /tmp/tellyplaylist)
dialog --infobox "Playlist: $tellyplaylist" 5 80
sleep 3

dialog --title "IPTV Number Of Streams" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "The ammount of concurrent streams your provider allows" 8 50 2>/tmp/tellystreams
tellystreams=$(cat /tmp/tellystreams)
dialog --infobox "Number Of Streams: $tellystreams" 3 45
sleep 3

dialog --infobox "Installing Telly: Please Wait" 3 35
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags telly &>/dev/null &
sleep 4
