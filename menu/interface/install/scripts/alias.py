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


# Import for Menu Interface
from consolemenu import *
from consolemenu.format import *
from consolemenu.items import *

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
rollover_item4 = RolloverItem("Configure RClone: ", "bash /opt/plexguide/menu/interface/pgmove/rclone.sh")
rollover_item2 = RolloverItem("Upload BW Limit : MB", "python3 /opt/plexguide/menu/interface/pgmove/speeds.py && python3 /opt/plexguide/menu/interface/pgmove/pgmove.py")
rollover_item3 = RolloverItem("Unable to Deploy: RClone Not Configured", "python3 /opt/plexguide/menu/interface/pgmove/pgmove.py")

# Once we're done creating them, we just add the items to the menu
menu.append_item(rollover_item4)
menu.append_item(rollover_item2)
menu.append_item(rollover_item3)

# Finally, we call show to show the menu and allow the user to interact
