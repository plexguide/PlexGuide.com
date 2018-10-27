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
from consolemenu.format import *
from consolemenu.items import *

# Import for Bash Ending
from subprocess import call

# Call Variables
with open('/var/plexguide/server.ports.status', 'r') as myfile:
    ports=myfile.read().replace('\n', '')

def main():
    # Change some menu formatting
    menu_format = MenuFormatBuilder().set_border_style_type(MenuBorderStyleType.HEAVY_BORDER)\
        .set_prompt("SELECT>")\
        .set_title_align('center')\
        .set_subtitle_align('center')\
        .set_left_margin(2)\
        .set_right_margin(2)\
        .set_top_margin(1)\
        .set_bottom_margin(1)\
        .show_header_bottom_border(True)

    menu = ConsoleMenu("Root Menu", "This is the Root Menu Subtitle", formatter=menu_format)
    item1 = MenuItem("Item 1", menu)

    # Create the menu
    Menu = ConsoleMenu("Root Menu", "This is the Root Menu Subtitle", formatter=menu_format)

    # A CommandItem runs a console command
    command_item1 = CommandItem("Mounts & Data Transport System ",  "bash /opt/plexguide/roles/menu-transport/scripts/main.sh")
    command_item2 = CommandItem("Traefik & TLD Deployment       ","bash /opt/plexguide/menu/interface/traefik/main.sh")
    command_item3 = CommandItem("Server Port Guard              " + ports,  "bash /opt/plexguide/roles/menu-ports/scripts/main.sh")
    command_item4 = CommandItem("Applicaiton Guard              ",  "bash /opt/plexguide/roles/menu-appguard/scripts/main.sh")
    command_item5 = CommandItem("Program Suite Installer",  "bash /opt/plexguide/menu/interface/apps/main.sh")
    command_item6 = CommandItem("PG Trak - Fills Up Radarr & Sonarr",  "bash /opt/plexguide/menu/interface/pgtrak/main.sh")
    # Once we're done creating them, we just add the items to the menu
    menu.append_item(command_item1)
    menu.append_item(command_item2)
    menu.append_item(command_item3)
    menu.append_item(command_item4)
    menu.append_item(command_item5)
    menu.append_item(command_item6)
    # Finally, we call show to show the menu and allow the user to interact
    menu.show()

if __name__ == "__main__":
    main()
# When User Exits Menu; Displays PG Ending
rc = call("/opt/plexguide/roles/ending/ending.sh", shell=True)
