#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/pgvault.func

# FIRST QUESTION

question1 () {

### Remove Running Apps
while read p; do
  sed -i "/^$p\b/Id" /var/plexguide/app.list
done </var/plexguide/pgvault.running

### Blank Out Temp List
rm -r /var/plexguide/program.temp && touch /var/plexguide/program.temp

### List Out Apps In Readable Order (One's Not Installed)
num=0
while read p; do
  echo -n $p >> /var/plexguide/program.temp
  echo -n " " >> /var/plexguide/program.temp
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /var/plexguide/program.temp
  fi
done </var/plexguide/app.list

notrun=$(cat /var/plexguide/program.temp)
buildup=$(cat /var/plexguide/pgvault.output)

if [ "$buildup" == "" ]; then buildup="NONE"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Vault ~ Data Storage             📓 Reference: pgvault.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Potential Data to Backup

$notrun

💾 Apps Queued for Backup

$buildup

💬 Quitting? TYPE > exit | 💪 Ready to Backup? TYPE > deploy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 TYPE App Name for Backup Queue | Press [ENTER]: ' typed < /dev/tty
echo

if [ "$typed" == "deploy" ]; then question2; fi

if [ "$typed" == "exit" ]; then exit; fi

current=$(cat /var/plexguide/pgvault.buildup | grep "\<$typed\>")
if [ "$current" != "" ]; then queued && question1; fi

current=$(cat /var/plexguide/pgvault.running | grep "\<$typed\>")
if [ "$current" != "" ]; then exists && question1; fi

current=$(cat /var/plexguide/program.temp | grep "\<$typed\>")
if [ "$current" == "" ]; then badinput1 && question1; fi

part1
}

part1 () {
echo "$typed" >> /var/plexguide/pgvault.buildup
num=0

touch /var/plexguide/pgvault.output && rm -rf /var/plexguide/pgvault.output

while read p; do
echo -n $p >> /var/plexguide/pgvault.output
echo -n " " >> /var/plexguide/pgvault.output
if [ "$num" == 7 ]; then
  num=0
  echo " " >> /var/plexguide/pgvault.output
fi
done </var/plexguide/pgvault.buildup

sed -i "/^$typed\b/Id" /var/plexguide/app.list

question1
}

final () {
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed < /dev/tty
  echo
  exit
}

question2 () {

# Image Selector
image=off
while read p; do

echo $p > /tmp/program_var

bash /opt/plexguide/containers/image/_image.sh
done </var/plexguide/pgvault.buildup

while read p; do
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG Vault - Backing Up: $p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 2.5

# Store Used Program
echo $p > /tmp/program_var
# Execute Main Program
ansible-playbook /opt/plexguide/menu/pgvault/backup.yml

sleep 2
done </var/plexguide/pgvault.buildup
echo "" >> /tmp/output.info
cat /tmp/output.info
final
}

# FUNCTIONS END ##############################################################
initial
question1
