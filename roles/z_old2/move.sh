#!/bin/bash

###########         For Developers Use Only         ###########
## Once finished with testing just comment out last commands ##
##     so that they can be used in the future if need be!    ##

## For testing new pgdrive encrypt new location
rm -r /opt/plexguide/menus/rclone/select.sh
mv /opt/plexguide/menus/rclone/select-new.sh /opt/plexguide/menus/rclone/select.sh

## For testing new pgdrive encrypt new location
rm -r /opt/plexguide/ansible/roles/pgdrive_en
mv /opt/plexguide/ansible/roles/pgdrive_en2 /opt/plexguide/ansible/roles/pgdrive_en
## For testing new pgdrive encrypt new location
#mv /opt/plexguide/ansible/roles/pgdrive_en/templates/move_script.js2 /opt/plexguide/ansible/roles/pgdrive_en/templates/move_script-old.js2
#mv /opt/plexguide/ansible/roles/pgdrive_en/templates/copy_move_script.js2 /opt/plexguide/ansible/roles/pgdrive_en/templates/move_script.js2
## For testing new pgdrive encrypt new location
rm -r /opt/plexguide/roles/pgdrivenav/encrypted.sh
mv /opt/plexguide/roles/pgdrivenav/encrypted-test.sh /opt/plexguide/roles/pgdrivenav/encrypted.sh

## For testing new encache config
#rm /opt/plexguide/ansible/roles/encache/templates/encache.js2
#mv /opt/plexguide/ansible/roles/encache/templates/encache2.js2 /opt/plexguide/ansible/roles/encache/templates/encache.js2

## For testing new pgdrive menus
#rm /opt/plexguide/roles/pgdrivenav/main.sh
#mv /opt/plexguide/roles/pgdrivenav/main2.sh /opt/plexguide/roles/pgdrivenav/main.sh

## For testing new info/services menus
#rm /opt/plexguide/roles/info-tshoot/info.sh
#mv /opt/plexguide/roles/info-tshoot/info-new.sh /opt/plexguide/roles/info-tshoot/info.sh

## For testing new beta menu
rm /opt/plexguide/menus/programs/beta.sh
mv /opt/plexguide/menus/programs/beta-new.sh /opt/plexguide/menus/programs/beta.sh

## For testing new backup menus
#rm /opt/plexguide/roles/backup/scripts/main.sh
#mv /opt/plexguide/menus/backup-restore/backup-new.sh /opt/plexguide/roles/backup/scripts/main.sh

## For testing new restore menus
#rm /opt/plexguide/menus/backup-restore/restore.sh
#mv /opt/plexguide/menus/backup-restore/restore-new.sh /opt/plexguide/menus/backup-restore/restore.sh

## For testing new rclone-en install
#rm /opt/plexguide/roles/z_old/rclone-en.sh
#mv /opt/plexguide/roles/z_old/rclone-en2.sh /opt/plexguide/roles/z_old/rclone-en.sh

## For testing new torrent menus
#rm /opt/plexguide/menus/programs/vpn.sh
#mv /opt/plexguide/menus/programs/vpn2.sh /opt/plexguide/menus/programs/vpn.sh

## For testing new info & services menus
#rm /opt/plexguide/roles/info-tshoot/info.sh
#mv /opt/plexguide/roles/info-tshoot/info-next.sh /opt/plexguide/roles/info-tshoot/info.sh

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

## For testing new pg.yml
#rm /opt/plexguide/pg.yml
#mv /opt/plexguide/ansible/plexguide2.yml /opt/plexguide/pg.yml

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
#rm -r /opt/plexguide/roles/z_old/rclone-en.sh
#mv /opt/plexguide/roles/z_old/rclone-entest.sh /opt/plexguide/roles/z_old/rclone-en.sh
