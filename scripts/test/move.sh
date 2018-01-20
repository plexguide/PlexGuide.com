#!/bin/bash

###########         For Developers Use Only         ###########
## Once finished with testing just comment out last commands ##
##     so that they can be used in the future if need be!    ##

## For testing new program menus
#mv /opt/plexguide/scripts/menus/programs /opt/plexguide/scripts/menus/programs4
#mv /opt/plexguide/scripts/menus/programs2 /opt/plexguide/scripts/menus/programs

## For testing new backup and restore menus
rm /opt/plexguide/scripts/menus/backup-menu.sh
rm /opt/plexguide/scripts/menus/restore-menu.sh
mv /opt/plexguide/scripts/menus/backup-menu2 /opt/plexguide/scripts/menus/backup-menu.sh
mv /opt/plexguide/scripts/menus/restore-menu2 /opt/plexguide/scripts/menus/restore-menu.sh

## For testing new service status and restart menus
#rm /opt/plexguide/scripts/menus/restart-menu.sh
#rm /opt/plexguide/scripts/menus/status-menu.sh
#mv /opt/plexguide/scripts/menus/restart-menu2.sh /opt/plexguide/scripts/menus/restart-menu.sh
#mv /opt/plexguide/scripts/menus/status-menu2.sh /opt/plexguide/scripts/menus/status-menu.sh

## For testing new var-vpn configs
#rm -r /opt/plexguide/ansible/roles/var-vpn
#mv /opt/plexguide/ansible/roles/var2 /opt/plexguide/ansible/roles/var-vpn
