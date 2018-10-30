#!/usr/bin/env python3
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

# Import for Bash Ending
from subprocess import call
# Install PlexGuide Console if Missing
rc = call("pip list --format columns --disable-pip-version-check | grep plexguide-menu > /var/plexguide/apip.check", shell=True)

with open('/var/plexguide/apip.check', 'r') as myfile:
    apip=myfile.read().replace('\n', '')

    if apip == '':
        rc = call("echo && echo 'Standby - Installing: PG Interface v0.0.3' && sleep 4 && echo && pip install git+git://github.com/Admin9705/plexguide-menu.git --disable-pip-version-check", shell=True)
