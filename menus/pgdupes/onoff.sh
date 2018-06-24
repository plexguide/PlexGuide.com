#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
export NCURSES_NO_UTF8_ACS=1
########################### START
                HEIGHT=10
                WIDTH=40
                CHOICE_HEIGHT=3
                BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
                TITLE="AutoDelete"
                MENU="Make a Selection:"

                OPTIONS=(A "AutoDelete: On (Default)"
                         B "AutoDelete: Off"
                         C "Mini FAQ")

                CHOICE=$(dialog --clear \
                                --backtitle "$BACKTITLE" \
                                --title "$TITLE" \
                                --menu "$MENU" \
                                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                "${OPTIONS[@]}" \
                                2>&1 >/dev/tty)

                clear
                case $CHOICE in
                        A)
                            echo "ON" > /var/plexguide/pgdupes.autodelete
                            echo "true" > /var/plexguide/pgdupes.autodelete2.json
                            dialog --title "AutoDelete Status" --msgbox "\nAutoDelete is [ON]! Now Go Break Things!\n\nMake sure to RERUN pgdupes!" 0 0
                            exit
                            ;;
                        B)
                            echo "OFF" > /var/plexguide/pgdupes.autodelete
                            echo "false" > /var/plexguide/pgdupes.autodelete2.json
                            dialog --title "AutoDelete Status" --msgbox "\nAutoDelete is [OFF]! Now Go Break Things!\n\nMake sure to RERUN pgdupes!" 0 0
                            exit
                            ;;
                        C)
                            display="$(cat /var/plexguide/plex.library)"
                            dialog --title "--- AutoDelete Info ---" --msgbox "\nBy Default, this is ON. The title speaks for itself.\n\nIf you leave AutoDelete On, it will make the best choice for you. Ideal if you DO NOT want to choose between 700 items.  For those obessed with making a decision, you can turn it OFF!." 0 0
                            exit
                            ;;
                esac

########## Deploy End
esac
exit
