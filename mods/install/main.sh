#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

## Simple Clone Process
mkdir -p /pg/tmp
rm -rf /pg/mods
rm -rf /pg/tmp/checkout
git clone -b alpha --single-branch https://github.com/PGBlitz/PGBlitz.com.git /pg/tmp/checkout
mv -f /pg/tmp/checkout/mods /pg

## Install PG Test Command
rm -rf /bin/install_test
cp /pg/mods/cmds/install_test /bin/install_test
chmod 775 /bin/install_test

## Create & Establish Functions Process
bash /pg/mods/functions/.create.sh
source /pg/mods/functions/.master.sh
################################################################################

install_sudocheck

common_message "🌎 INSTALLING: PlexGuide.com GNUv3 License" "
By Installing PlexGuide, you are agreeing to the terms and conditions of the
GNUv3 License!

If you have a chance to donate, please visit https://donate.plexguide.com
PRESS CTRL+Z to STOP the Installation
"
common_timer "2" ## set back to 5

install_folders
# install_drivecheck
# install_webservercheck
# install_oscheck
# install_basepackage
# install_pyansible
# install_dependency

# ansible-playbook /pg/mods/motd/motd.yml

#common_header "⌛ INSTALLING: Docker"; sleep 2
#ansible-playbook /pg/mods/ymls/pg.yml --tags docker

common_header "⌛ INSTALLING: RClone"; sleep 2
ansible-playbook /pg/mods/ymls/pg.yml --tags rcloneinstall

common_header "⌛ INSTALLING: Google's Cloud SDK"; sleep 2
ansible-playbook /pg/mods/ymls/pg.yml --tags google_sdk

echo "HALTED - Install Check  "

exit
