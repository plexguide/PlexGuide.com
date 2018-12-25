#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate & PhysK
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
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/keys.sh
source /opt/plexguide/menu/functions/keyback.sh
source /opt/plexguide/menu/functions/pgclone.sh
################################################################################
mkdir -p /opt/appdata/pgblitz/keys/processed
path=/opt/appdata/pgblitz/keys/processed

#updated to cleaner method by PhysK
cat $path/* | grep client_email | awk '{print $2}' | sed 's/"//g' | sed 's/,//g' > /tmp/pgblitz.emails.list
touch /tmp/pgblitz.emails.list

emailcheck=$(cat /tmp/pgblitz.emails.list)
if [ "$emailcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! You Need to Generate Keys before Executing This!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
keymenu
fi

echo
echo "Welcome to the PG Blitz - EMail Share Generator"
echo ""
echo "In GDRIVE, share the teamdrive with the following emails:"
echo ""
echo "NOTE 1: Make sure you SHARE with the CORRECT TEAM DRIVE!"
echo "NOTE 2: Save Time & Copy & Paste the E-Mails Into the G-Drive Share!"
echo
cat /tmp/pgblitz.emails.list
echo "INFO - PGBlitz: Displayed to User the E-Mails" > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
