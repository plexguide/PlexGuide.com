#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
## To Get List for Rebuilding or TLD
docker ps --format '{{.Names}}' > /tmp/backup.list
sed -i -e "/traefik/d" /tmp/backup.list
sed -i -e "/watchtower/d" /tmp/backup.list
sed -i -e "/wp-*/d" /tmp/backup.list
sed -i -e "/x2go*/d" /tmp/backup.list
sed -i -e "/plexguide/d" /tmp/backup.list
sed -i -e "/cloudplow/d" /tmp/backup.list
sed -i -e "/phlex/d" /tmp/backup.list

rm -rf /tmp/backup.build 1>/dev/null 2>&1
#### Commenting Out To Let User See
while read p; do
  echo -n "$p" >> /tmp/backup.build
  echo -n " " >> /tmp/backup.build
done </tmp/backup.list
running=$(cat /tmp/backup.list)

# If Blank, Exit
if [ "$running" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - No Apps are Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
exit
fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Provider Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
echo PROGRAMS:
echo $running
tee <<-EOF

⚠️  NOTE: App Must Be Actively Running! To quit, type >>> exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type an Application Name | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "exit" ]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [ "$tcheck" == "" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /opt/plexguide/menu/traefik/tld.sh
exit
fi

if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The TLD Application Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /opt/plexguide/menu/traefik/tld.sh
exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Prevents From Repeating
cat /var/plexguide/tld.program > /var/plexguide/old.program
echo "$typed" > /var/plexguide/tld.program

sleep 3
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 4
old=$(cat /var/plexguide/old.program)
new=$(cat /var/plexguide/tld.program)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then ansible-playbook /opt/plexguide/containers/$old.yml; fi

ansible-playbook /opt/plexguide/containers/$new.yml
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ TLD Containers are Rebuilt!  Process Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 4
