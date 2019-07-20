#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
#################################################################################

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

weekrandom() {
  while read p; do
    echo "$p" >/tmp/program_var
    echo $(($RANDOM % 23)) >/var/plexguide/cron/cron.hour
    echo $(($RANDOM % 59)) >/var/plexguide/cron/cron.minute
    echo $(($RANDOM % 6)) >/var/plexguide/cron/cron.day
    ansible-playbook /opt/plexguide/menu/cron/cron.yml
  done </var/plexguide/pgbox.buildup
  exit
}

dailyrandom() {
  while read p; do
    echo "$p" >/tmp/program_var
    echo $(($RANDOM % 23)) >/var/plexguide/cron/cron.hour
    echo $(($RANDOM % 59)) >/var/plexguide/cron/cron.minute
    echo "*/1" >/var/plexguide/cron/cron.day
    ansible-playbook /opt/plexguide/menu/cron/cron.yml
  done </var/plexguide/pgbox.buildup
  exit
}

manualuser() {
  while read p; do
    echo "$p" >/tmp/program_var
    bash /opt/plexguide/menu/cron/cron.sh
  done </var/plexguide/pgbox.buildup
  exit
}

# FIRST QUESTION
question1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Cron - Schedule Cron Jobs (Backups) | Mass Program Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://cron.pgblitz.com

[1] No  [Skip   - All Cron Jobs]
[2] Yes [Manual - Select for Each App]
[3] Yes [Daily  - Select Random Times]
[4] Yes [Weekly - Select Random Times & Days]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    exit
  elif [ "$typed" == "2" ]; then
    manualuser && ansible-playbook /opt/plexguide/menu/cron/cron.yml
  elif [ "$typed" == "3" ]; then
    dailyrandom && ansible-playbook /opt/plexguide/menu/cron/cron.yml
  elif [ "$typed" == "4" ]; then
    weekrandom && ansible-playbook /opt/plexguide/menu/cron/cron.yml
  else badinput1; fi
}

question1
