#!/bin/bash

###########         For Developers Use Only         ###########
## Once finished with testing just comment out last commands ##
##     so that they can be used in the future if need be!    ##

## For testing new info/services menus
rm /opt/plexguide/menus/info-tshoot/info.sh
mv /opt/plexguide/menus/info-tshoot/info-new.sh /opt/plexguide/menus/info-tshoot/info.sh

## For testing new beta menu
rm /opt/plexguide/menus/programs/beta.sh
mv /opt/plexguide/menus/programs/beta-new.sh /opt/plexguide/menus/programs/beta.sh

## For testing new backup menus
#rm /opt/plexguide/menus/backup-restore/backup.sh
#mv /opt/plexguide/menus/backup-restore/backup-new.sh /opt/plexguide/menus/backup-restore/backup.sh

## For testing new restore menus
#rm /opt/plexguide/menus/backup-restore/restore.sh
#mv /opt/plexguide/menus/backup-restore/restore-new.sh /opt/plexguide/menus/backup-restore/restore.sh

## For testing new rclone-en install
#rm /opt/plexguide/scripts/docker-no/rclone-en.sh
#mv /opt/plexguide/scripts/docker-no/rclone-en2.sh /opt/plexguide/scripts/docker-no/rclone-en.sh

## For testing new torrent menus
#rm /opt/plexguide/menus/programs/vpn.sh
#mv /opt/plexguide/menus/programs/vpn2.sh /opt/plexguide/menus/programs/vpn.sh

## For testing new info & services menus
#rm /opt/plexguide/menus/info-tshoot/info.sh
#mv /opt/plexguide/menus/info-tshoot/info-next.sh /opt/plexguide/menus/info-tshoot/info.sh

## For testing new torrent menus
#rm /opt/plexguide/menus/programs/beta.sh
#mv /opt/plexguide/menus/programs/beta-next.sh /opt/plexguide/menus/programs/beta.sh

## For testing new torrent menus
#rm /opt/plexguide/menus/programs/torrent.sh
#mv /opt/plexguide/menus/programs/torrent-next.sh /opt/plexguide/menus/programs/torrent.sh

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
#rm /opt/plexguide/scripts/menus/backup-menu.sh
#rm /opt/plexguide/scripts/menus/restore-menu.sh
#mv /opt/plexguide/scripts/menus/backup-menu2 /opt/plexguide/scripts/menus/backup-menu.sh
#mv /opt/plexguide/scripts/menus/restore-menu2 /opt/plexguide/scripts/menus/restore-menu.sh

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
