
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
rc = call("cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'tcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone.tcrypt", shell=True)
rc = call("cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gcrypt", shell=True)

# Import for Menu Interface
from consolemenu import *
from consolemenu.format import *
from consolemenu.items import *

# Call Variables
with open('/var/plexguide/rclone.gdrive', 'r') as myfile:
    gdrive=myfile.read().replace('\n', '')

with open('/var/plexguide/rclone.gcrypt', 'r') as myfile:
    gcrypt=myfile.read().replace('\n', '')

with open('/var/plexguide/move.bw', 'r') as myfile:
    bwlimit=myfile.read().replace('\n', '')
############## Traefik Detection
if gdrive != '' and gcrypt == '':
    configure = "[UnEncrypted]"
elif gdrive != '' and gcrypt != '':
    configure = "[Encrypted]"
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

menu = ConsoleMenu("Welcome to PG Move!",
                   prologue_text=("PG Move is a simple uploader. It is highly recommend that you keep the BW @ 9MB; equaling 750GB per day over a period of 24 horus! If uploading less than 750GB per day, user can increase the speeds! Making Changes? Redeploy PG Move!"))
menu.formatter = menu_format
item1 = MenuItem("Item 1", menu)

# A CommandItem runs a console command
command_item2 = CommandItem("Configure RClone: " + configure,"echo && rclone config && mkdir -p /root/.config/rclone/ && chown -R 1000:1000 /root/.config/rclone/ && cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1 && echo")
rollover_item2 = RolloverItem("Upload BW Limit : " + bwlimit + " MB", "python3 /opt/plexguide/menu/interface/pgmove/speeds.py && python3 /opt/plexguide/menu/interface/pgmove/pgmove.py")

if configure == '[Encrypted]':
    command_item1 = CommandItem("Deploy PG Move - Encrypted /w PG Drives", "ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted")
elif configure == '[UnEncrypted]':
    command_item1 = CommandItem("Deploy PG Move - Unencrypted /w PG Drives", "ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted")
else:
    command_item1 = CommandItem("Unable to Deploy - RClone Not Configured", "echo")

# Once we're done creating them, we just add the items to the menu
menu.append_item(command_item2)
menu.append_item(rollover_item2)
menu.append_item(command_item1)

# Finally, we call show to show the menu and allow the user to interact
menu.show()
