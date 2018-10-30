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

# Needed for Sleep Equiv Bash Function
import time

# Import for Bash Ending
from subprocess import call

# If a Variable is Missing, this will ensure it's there
rc = call("touch /var/plexguide/pg.motd.stored", shell=True)

# Call Variables
with open('/var/plexguide/pg.motd', 'r') as myfile:
    starter=myfile.read().replace('\n', '')

with open('/var/plexguide/pg.motd.stored', 'r') as myfile:
    stored=myfile.read().replace('\n', '')

# (MENU START) If True, then Continue; If Not, Do Nothing!
if starter != stored:

    # Execute Ansible Function
    rc = call("ansible-playbook /opt/plexguide/pg.yml --tags motd", shell=True)

    # If Successful, Make them Equal to Prevent Future Execution!
    rc = call("cat /var/plexguide/pg.motd > /var/plexguide/pg.motd.stored", shell=True)
