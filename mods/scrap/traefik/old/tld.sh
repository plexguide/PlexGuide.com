#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# To Get List for Rebuilding or TLD
docker ps --format '{{.Names}}' >/tmp/backup.list
sed -i -e "/traefik/d" /tmp/backup.list
sed -i -e "/watchtower/d" /tmp/backup.list
sed -i -e "/wp-*/d" /tmp/backup.list
sed -i -e "/x2go*/d" /tmp/backup.list
sed -i -e "/plexguide/d" /tmp/backup.list
sed -i -e "/cloudplow/d" /tmp/backup.list
sed -i -e "/oauth/d" /tmp/backup.list
sed -i -e "/pgui/d" /tmp/backup.list

rm -rf /tmp/backup.build 1>/dev/null 2>&1
#### Commenting Out To Let User See
while read p; do
  echo -n "$p" >>/tmp/backup.build
  echo -n " " >>/tmp/backup.build
done </tmp/backup.list
running=$(cat /tmp/backup.list)

# If Blank, Exit
if [ "$running" == "" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - No Apps are Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 2
  exit
fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Provider Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: App Must Be Actively Running!

EOF
echo PROGRAMS:
echo $running
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
read -p 'Type an Application Name | Press [ENTER] | [Z] Exit: ' typed </dev/tty

if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [ "$tcheck" == "" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 3
  bash /opt/traefik/tld.sh
  exit
fi

if [ "$typed" == "" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The TLD Application Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 3
  bash /opt/traefik/tld.sh
  exit
else
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  # Prevents From Repeating
  cat /pg/var/tld.program >/pg/var/old.program
  echo "$typed" >/pg/var/tld.program

  sleep 3
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 4
old=$(cat /pg/var/old.program)
new=$(cat /pg/var/tld.program)

touch /pg/var/tld.type
tldtype=$(cat /pg/var/tld.type)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then

  if [[ "$tldtype" == "standard" ]]; then
    if [ -e "/opt/coreapps/apps/$old.yml" ]; then ansible-playbook /opt/coreapps/apps/$old.yml; fi
    if [ -e "/opt/communityapps/$old.yml" ]; then ansible-playbook /opt/communityapps/apps/$old.yml; fi
  elif [[ "$tldtype" == "wordpress" ]]; then
    echo "$old" >/tmp/wp_id
    ansible-playbook /opt/pgpress/wordpress.yml
    echo "$typed" >/tmp/wp_id
  fi

fi

if [ -e "/opt/coreapps/apps/$new.yml" ]; then ansible-playbook /opt/coreapps/apps/$new.yml; fi
if [ -e "/opt/communityapps/$new.yml" ]; then ansible-playbook /opt/communityapps/apps/$new.yml; fi
echo "standard" >/pg/var/tld.type
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '✅️ Process Complete! Acknowledge Info | Press [ENTER] ' name </dev/tty
