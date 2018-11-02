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
from subprocess import call
import time

with open('/var/plexguide/pg.id', 'r') as myfile:
    starter=myfile.read().replace('\n', '')

with open('/var/plexguide/pg.id.stored', 'r') as myfile:
    stored=myfile.read().replace('\n', '')

# (MENU START) If True, then Continue; If Not, Do Nothing!
if starter != stored:

    question = "\nSet Server ID to what? Then Press [ENTER] "
    print (question)
    answer = input()

    f = open('/var/plexguide/server.id', 'w')
    f.write(answer)
    f.close()

    print ("\nServer ID Set To >>>: " + answer + "!")

    rc = call("cat /var/plexguide/pg.id > /var/plexguide/pg.id.stored", shell=True)

    time.sleep(3)
