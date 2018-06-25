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
export NCURSES_NO_UTF8_ACS=1

if dialog --stdout --title "Use Local Storage - No GDrive Upload" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nHave you have read the WIKI on configuring Plexguide with Local Storage?" 7 50; then
  clear
else
  clear
  dialog --title "Use Local Storage - No GDrive Upload" --msgbox "\nPlease read the WIKI first otherwise you may break your PG install!" 0 0
  exit 0
fi
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags localstorage 1>/dev/null 2>&1