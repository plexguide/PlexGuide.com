#!/bin/bash -i

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

alias sgdrive='sudo systemctl status gdrive's
alias ngdrive='sudo nano /etc/systemd/system/gdrive.service && systemctl daemon-reload'

alias stdrive='sudo systemctl status tdrive'
alias ntdrive='sudo nano /etc/systemd/system/tdrive.service && systemctl daemon-reload'

alias sunionfs='sudo systemctl status unionfs'
alias nunionfs='sudo nano /etc/systemd/system/unionfs.service && systemctl daemon-reload'

alias smove='sudo systemctl status move'
alias nmove='sudo nano /etc/systemd/system/move.service && systemctl daemon-reload'

alias sst2='sudo systemctl status supertransfer2'
alias ssupertransfer2='sudo systemctl status supertransfer2'

alias sst4='sudo systemctl status supertransfer2'