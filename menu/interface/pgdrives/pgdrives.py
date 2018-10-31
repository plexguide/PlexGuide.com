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
rc = call("cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.tdrive", shell=True)
rc = call("cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gdrive", shell=True)

# Import for Menu Interface
from consolemenu import *
from consolemenu.format import *
from consolemenu.items import *

# Call Variables
with open('/var/plexguide/rclone.gdrive', 'r') as myfile:
    gdrive=myfile.read().replace('\n', '')

with open('/var/plexguide/rclone.tdrive', 'r') as myfile:
    tdrive=myfile.read().replace('\n', '')

############## Traefik Detection
if gdrive != '' and tdrive == "":
    configure = "[GDrive]"
elif gdrive != '' and tdrive != '':
    configure = "[GDrive /w TeamDrive]"
else:
    configure = "[Not Configured]"

# Menu Start

    # Change some menu formatting
menu_format = MenuFormatBuilder().set_border_style_type(MenuBorderStyleType.HEAVY_BORDER)\
    .set_prompt("SELECT>")\
    .set_title_align('left')\
    .set_subtitle_align('left')\
    .set_left_margin(2)\
    .set_right_margin(2)\
    .show_header_bottom_border(True)

menu = ConsoleMenu("Welcome to PG Drives!",
                   prologue_text=("The PG Drives option is only for READ ONLY Servers! When you deploy this, there is no movement of files! Your Google Drive (and TeamDrive if Configured) are deployed! This is great for a PLEX Only Server & etc!"))
menu.formatter = menu_format
item1 = MenuItem("Item 1", menu)

# A CommandItem runs a console command
rollover_item4 = RolloverItem("Configure RClone: " + configure, "bash /opt/plexguide/menu/interface/pgdrives/rclone.sh")
if configure == '[GDrive]':
    rollover_item3 = RolloverItem("Deploy PG Drives: Google Drive", "echo '/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath && ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml && ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives --skip-tags encrypted && python3 /opt/plexguide/menu/interface/pgdrives/pgdrives.py")
elif configure == '[GDrive /w TeamDrive]':
    rollover_item3 = RolloverItem("Deploy PG Drives: Google Drive /w TeamDrives", "echo '/mnt/tdrive=RO:/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath && ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml && ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives --skip-tags encrypted && python3 /opt/plexguide/menu/interface/pgdrives/pgdrives.py")
else:
    # Future Wise, put Warning Script to Call Bash or Python Script
    rollover_item3 = RolloverItem("Unable to Deploy: RClone Not Configured", "python3 /opt/plexguide/menu/interface/pgdrives/pgdrives.py")

# Once we're done creating them, we just add the items to the menu
menu.append_item(rollover_item4)
menu.append_item(rollover_item3)

# Finally, we call show to show the menu and allow the user to interact
menu.show()
