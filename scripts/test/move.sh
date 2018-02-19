#!/bin/bash

###########         For Developers Use Only         ###########
## Once finished with testing just comment out last commands ##
##     so that they can be used in the future if need be!    ##

## For testing new status and restart menus
#rm /opt/plexguide/scripts/menus/status-menu.sh
#rm /opt/plexguide/scripts/menus/restart-menu.sh
#mv /opt/plexguide/scripts/menus/status-menu2.sh /opt/plexguide/scripts/menus/status-menu.sh
#mv /opt/plexguide/scripts/menus/restart-menu2.sh /opt/plexguide/scripts/menus/restart-menu.sh

## For testing new plexguide.yml
#rm /opt/plexguide/ansible/plexguide.yml
#mv /opt/plexguide/ansible/plexguide2.yml /opt/plexguide/ansible/plexguide.yml

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

## For testing new folders setup
#rm -r /opt/plexguide/ansible/roles/folders
#mv /opt/plexguide/ansible/roles/foldersX /opt/plexguide/ansible/roles/folders

## For testing new rclone-en setup
#rm -r /opt/plexguide/scripts/docker-no/rclone-en.sh
#mv /opt/plexguide/scripts/docker-no/rclone-entest.sh /opt/plexguide/scripts/docker-no/rclone-en.sh
