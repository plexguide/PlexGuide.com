#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
keybackup () {

serverid=($cat /var/plexguide/pg.serverid)

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Backing Up to GDrive - Server ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty

rclone copy {{tarlocation.stdout}}/{{program_var.stdout}}.tar gdrive:/plexguide/backup/{{server_id.stdout}} -v --checksum --drive-chunk-size=64M

}
