#!/bin/bash
#
# [Ansible Role]
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
# https://pypi.org/project/console-menu/

# Import for Menu Interface
from consolemenu import *
from consolemenu.items import *

# Import for Bash Ending
from subprocess import call

a = "[Open]"
# Create the menu
menu = ConsoleMenu("Welcome to PlexGuide.com")

# A CommandItem runs a console command
command_item1 = CommandItem("Mounts  & Transport System " + a,  "bash /opt/plexguide/roles/menu-transport/scripts/main.sh")

# Once we're done creating them, we just add the items to the menu
menu.append_item(command_item1)

# Finally, we call show to show the menu and allow the user to interact
menu.show()

# When User Exits Menu; Displays PG Ending
rc = call("/opt/plexguide/roles/ending/ending.sh", shell=True)
