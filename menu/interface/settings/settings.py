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

# Call Variables
with open('/var/plexguide/pg.edition', 'r') as myfile:
    edition=myfile.read().replace('\n', '')

def main():
    # Change some menu formatting
    menu_format = MenuFormatBuilder().set_border_style_type(MenuBorderStyleType.HEAVY_BORDER)\
        .set_prompt("SELECT>")\
        .set_title_align('left')\
        .set_subtitle_align('left')\
        .set_left_margin(2)\
        .set_right_margin(2)\
        .show_header_bottom_border(False)

    menu = ConsoleMenu("Settings Interface Menu", formatter=menu_format)
    item1 = MenuItem("Item 1", menu)

    # A CommandItem runs a console command
    command_item1 = CommandItem("Download Path  : Change the Processing Location", "bash /opt/plexguide/menu/interface/dlpath/main.sh")
    command_item2 = CommandItem("Processor      : Enhance Processing Power", "bash /opt/plexguide/roles/processor/scripts/processor-menu.sh")
    command_item3 = CommandItem("Kernal Modes   : Enhance Network Throughput", "bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh")
    command_item4 = CommandItem("WatchTower     : Auto-Update Application Manager", "bash /opt/plexguide/menu/interface/watchtower/file.sh")
    command_item5 = CommandItem("Change Time    : Change the Server Time", "dpkg-reconfigure tzdata")
    # Once we're done creating them, we just add the items to the menu
    menu.append_item(command_item1)
    menu.append_item(command_item2)
    menu.append_item(command_item3)
    menu.append_item(command_item4)
    menu.append_item(command_item5)
    # Finally, we call show to show the menu and allow the user to interact
    menu.show()

if __name__ == "__main__":
    main()
