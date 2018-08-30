#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   PhysK (Project Manager for Automations) & Teresa (Gifted Python Coder) & Admin9705 (The Cleanup Guy)
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
echo "INFO - Setting Automated SA flag"  > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
mkdir -p /opt/appdata/pgblitz/vars/
mkdir -p /opt/appdata/pgblitz/keys/automation
touch /opt/appdata/pgblitz/vars/automated

echo "INFO - Installing Requirements" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
echo 'INFO - USING AUTO SA CREATION TOOL' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
echo 'INFO - RUNNING Auto SA Tool by Teresa' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

#dialog --title "WARNING!" --msgbox "\nMake Sure you have read the Wiki for using the Auto SA Tool!" 0 0

### Python Script Prep
ansible-playbook /opt/plexguide/roles/menu-pgblitz/pre.yml

echo ""
echo "NOTE: Pay Attention! USE the ACCOUNT of Your Business G-Suite!"
echo "Failing to do so will [RESULT] in Script Failure!"
cd /opt/plexguide/roles/menu-pgblitz/scripts/
python3 pgblitz.py
if [ $? == 1 ]; then
    echo ""
    read -n 1 -s -r -p "PGBlitz.Py Could Not Execute due to an Internal Error! Press [Any Key] to Continue"
    exit
fi

if [ -e /root/.config/rclone/rclone.config ]; then
    mv /root/.config/rclone/rclone.conf /root/.config/rclone/rclone.conf.old
    echo ""
    read -n 1 -s -r -p "You're old rclone config has been moved to /root/.config/rclone/rclone.conf.old - Press [Any Key] to Continue"
fi
mv /opt/appdata/pgblitz/keys/automation/rclone.conf /root/.config/rclone/rclone.conf

#### BLANK OUT PATH - This Builds For UnionFS
rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

### Build UnionFS Paths Based on Version
echo -n "/mnt/gdrive=RO:/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath

### Add GDSA Paths for UnionFS
bash /opt/plexguide/roles/menu-pgblitz/scripts/ufbuilder.sh
temp=$( cat /tmp/pg.gdsa.build )
echo -n "$temp" >> /var/plexguide/unionfs.pgpath

### Remove All Key Prior Services Related To Mounts
ansible-playbook /opt/plexguide/roles/menu-pgblitz/service-remove

ansible-playbook /opt/plexguide/pg.yml --tags pgblitz --skip-tags encrypted
ansible-playbook /opt/plexguide/pg.yml --tags blitzui
echo ""
echo "The PG Blitz TEAM"
echo "--------------------------------------------------------------------------"
echo "PG Blitz: Admin9705   | Blitz Automations: Teresa (visit: http://wckd.app)"
echo "Inspired: FlickerRate | Blitz UI: Physk (visit: https://github.com/physk)"
echo "Contributers: Bryde"
echo "--------------------------------------------------------------------------"
echo ""
echo "NOTE: BlitzUI deployed to blitzui.domain.com | domain.com:43242 | ipv4:43242"
echo ""
read -n 1 -s -r -p "PGBlitz & PGDrives Deployed! Press [ANY KEY] to Continue"
