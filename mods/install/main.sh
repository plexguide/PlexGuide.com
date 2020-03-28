#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

if [[ "$pgcmd" != "true" ]]; then
## Simple Clone Process
mkdir -p /pg/tmp
rm -rf /pg/mods
rm -rf /pg/tmp/checkout
git clone -b alpha --single-branch https://github.com/plexguide/PlexGuide.com.git /pg/tmp/checkout
mv -f /pg/tmp/checkout/mods /pg

## Install PG Test Command
rm -rf /bin/install_test
cp /pg/mods/cmds/install_test /bin/install_test
chmod 775 /bin/install_test

## Create & Establish Functions Process
bash /pg/mods/functions/.create.sh
source /pg/mods/functions/.master.sh; fi
################################################################################

install_sudocheck

if [[ "$pgcmd" != "true" ]]; then

common_message "🌎 INSTALLING: PlexGuide.com GNUv3 License" "
By Installing PlexGuide, you are agreeing to the terms and conditions of the
GNUv3 License!

If you have a chance to donate, please visit https://donate.plexguide.com
PRESS CTRL+Z to STOP the Installation
"
common_timer "1" ## set back to 5
fi

## delete
mkdir -p /pg/var/install/
install_check

common_install install_folders
install_cmds
#install_oldpg ## not need unless we come out with PG11+ that requires a block
common_install install_drivecheck
common_install install_webservercheck
common_install install_oscheck
common_install install_basepackage
common_install install_pyansible
common_install install_dependency

# ansible-playbook /pg/mods/motd/motd.yml

common_install install_docker
common_install install_docker_start
common_install install_rclone
common_install install_mergerfs
common_install install_gcloud_sdk
common_install install_nvidia

############# DO NOT ACTIVE TILL PGUNION
#common_header "⌛ INSTALLING: MergerFS Update"; sleep 2
#ansible-playbook /pg/mods/ymls/pg.yml --tags mergerfsupdate

bash /pg/mods/start/start.sh

exit
