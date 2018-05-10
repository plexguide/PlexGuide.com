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
domain=$( cat /var/plexguide/server.domain )
ipv4=$( cat /var/plexguide/server.ip )
program=$( cat /tmp/program )
port=$( cat /tmp/port )
program_extra=$( cat /tmp/program_extra )
port_extra=$( cat /tmp/port_extra )

dialog --title "$display - Address Info" \
--msgbox "\nIPv4      - http://$ipv4:$port\nIPv4      - http://$ipv4:$port_extra\nSubdomain - https://$program.$domain\nSubdomain - https://$program_extra.$domain\nDomain    - http://$domain:$port\nDomain    - http://$domain:$port_extra" 11 50
# --msgbox "\nIPv4      - http://$ipv4:$port_extra\nSubdomain - https://$program_extra.$domain\nDomain    - http://$domain:$port_extra" 8 50
