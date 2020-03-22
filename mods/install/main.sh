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

common_message "⛔️ READ THIS NOTE" "
PlexGuide.com advises that while utilizing PG, there is an inhert risk that
your data may be lost if you fail to control your own GSuite Account; Control
your OWN data! You've been warned!"
common_confirm

echo "HALTED"
