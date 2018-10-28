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

# Pip Install Menu Fails to Exist
rc = call("pip list --format columns --disable-pip-version-check | grep console-menu > /var/plexguide/apip.check", shell=True)

with open('/var/plexguide/apip.check', 'r') as myfile:
    apip=myfile.read().replace('\n', '')

    if apip == '':
        rc = call("pip install console-menu", shell=True)
