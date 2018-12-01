#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
#################################################################################

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

weekrandom () {
  while read p; do
  echo $(($RANDOM % 23)) > /var/plexguide/cron/cron.hour
  echo $(($RANDOM % 59)) > /var/plexguide/cron/cron.minute
  echo $(($RANDOM % 6))> /var/plexguide/cron/$p.cron.day
  ansible-playbook /opt/plexguide/menu/cron/cron.yml
  done </var/plexguide/pgbox.buildup
  exit
}

dailyrandom () {
  while read p; do
  echo $(($RANDOM % 23)) > /var/plexguide/cron/cron.hour
  echo $(($RANDOM % 59)) > /var/plexguide/cron/cron.minute
  echo "*/1" > /var/plexguide/cron/$program.cron.day
  ansible-playbook /opt/plexguide/menu/cron/cron.yml
  done </var/plexguide/pgbox.buildup
  exit
}

# FIRST QUESTION
question1 () {
space=$(cat /var/plexguide/data.location)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Cron - Schedule Cron Jobs (Backups) | Mass Program Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://cron.plexguide.com

1 - No  [Skip   - All Cron Jobs]
2 - Yes [Manual - Select for Each App]
3 - Yes [Daily  - Select Random Times]
4 - Yes [Weekly - Select Random Times & Days]
5 - Backup Location: $space

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then exit;
elif [ "$typed" == "2" ]; then ansible-playbook /opt/plexguide/menu/cron/remove.yml && exit;
elif [ "$typed" == "3" ]; then dailyrandom && ansible-playbook /opt/plexguide/menu/cron/cron.yml;
elif [ "$typed" == "4" ]; then week && ansible-playbook /opt/plexguide/menu/cron/cron.yml;
else badinput1; fi
}

question1
