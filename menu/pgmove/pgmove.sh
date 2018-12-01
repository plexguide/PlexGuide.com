#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

rclonestage () {
mkdir -p /root/.config/rclone/
chown -R 1000:1000 /root/.config/rclone/
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
}

defaultvars () {
  touch /var/plexguide/rclone.gdrive
  touch /var/plexguide/rclone.gcrypt
}

bandwidth () {

# Standby
read -p 'TYPE a SERVER SPEED from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty

if [ $typed -gt 1000 -o $typed -lt 1 ]; then badinput && bandwith;
else echo "$typed" > /var/plexguide/move.bw
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED: Bandwidth Limit Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
fi
}

question1 () {
variable /var/plexguide/move.bw "10"

cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gcrypt
cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gdrive

# Declare Ports State
gdrive=$(cat /var/plexguide/rclone.gdrive)
gcrypt=$(cat /var/plexguide/rclone.gcrypt)

  if [ "$gdrive" != "" ] && [ "$gcrypt" == "" ]; then configure="GDrive" && message="Deploy PG Drives: GDrive";
elif [ "$gdrive" != "" ] && [ "$gcrypt" != "" ]; then configure="GDrive /w GCrypt" && message="Deploy PG Drives : GDrive /w GCrypt";
else configure="Not Configured" && message="Unable to Deploy : RClone is Unconfigured"; fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Welcome to PG Move
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: PG Move utilizes only GDrive (no teamdrives)! PG Move will allow
you to move up to 750GB per day! If you need more, please switch to
teamdrive. You can configure and add gcrypt for encryptions (follow the
wiki). A 10MB speed is the safe limit if your going to upload
constantly for 24 hours!

1 - Configure RClone : $configure
2 - Configure BWLimit: $speed MB
3 - $message
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    rclone config
    rclonestage
elif [ "$typed" == "2" ]; then
    bandwidth
elif [ "$typed" == "3" ]; then
    if [ "$configure" == "GDrive" ]; then
    echo '/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted
    elif [ "$configure" == "GDrive /w GCrypt" ]; then
    echo '/mnt/gcrypt=RO:/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move
    else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! WARNING! WARNING! You Need to Configure: gdrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 4
  fi
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
  exit
else
  bash /opt/plexguide/menu/pgmove/pgmove.sh
  exit
fi

bash /opt/plexguide/menu/pgmove/pgmove.sh
exit
}

question1
