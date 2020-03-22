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

PRESS CTRL+Z to STOP the Installation
"
common_timer "5"

echo "HALTED"
