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

# Import for Menu Interface
from consolemenu import *
from consolemenu.format import *
from consolemenu.items import *

# If a Variable is Missing, this will ensure it's there
rc = call("touch /var/plexguide/pg.rclone.stored", shell=True)

# Call Variables
with open('/var/plexguide/pg.rclone', 'r') as myfile:
    starter=myfile.read().replace('\n', '')

with open('/var/plexguide/pg.rclone.stored', 'r') as myfile:
    stored=myfile.read().replace('\n', '')

# (MENU START) If True, then Continue; If Not, Do Nothing!
if starter != stored:

    # Change some menu formatting
    menu_format = MenuFormatBuilder().set_border_style_type(MenuBorderStyleType.HEAVY_BORDER)\
        .set_prompt("")\
        .set_title_align('center')\
        .set_subtitle_align('left')\
        .set_left_margin(2)\
        .set_right_margin(2)\
        .show_header_bottom_border(True)

    menu = ConsoleMenu("INSTALLING: RClone",
                       prologue_text=("RClone mounts your Google Drive as a pseudo Hard Drive! PLEASE STANDBY!"))
    menu.formatter = menu_format
    item1 = MenuItem("Item 1", menu)
    # Finally, we call show to show the menu and allow the user to interact
    menu.start()

    # Sleep 5 Seconds
    time.sleep(5)

    # Execute Ansible Function
    rc = call("ansible-playbook /opt/plexguide/pg.yml --tags rcloneinstall", shell=True)

    # If Successful, Make them Equal to Prevent Future Execution!
    rc = call("cat /var/plexguide/pg.rclone > /var/plexguide/pg.rclone.stored", shell=True)

    # Required for RClone to Work
    rc = call("bash /opt/plexguide/menu/interface/install/scripts/rclone.sh", shell=True)

    # Sleeps
    time.sleep(3)
