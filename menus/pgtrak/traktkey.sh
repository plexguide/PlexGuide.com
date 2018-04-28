#!/bin/bash
#
# [Key Storage]
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

dialog --title "Trakt Requested Information" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Trakt API-Key:" 8 45 2>/var/plexguide/api.trakkey
key=$(cat /var/plexguide/api.trakkey)
dialog --infobox "Entered API Key: $key" 0 0

if dialog --stdout --title "API Question?" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --yesno "\nAPI Correct? $key" 0 0; then
    easteregg="foundme"
else
	rm -r /var/plexguide/api.trakkey
    bash /opt/plexguide/menus/pgtrak/traktkey.sh
    exit
fi