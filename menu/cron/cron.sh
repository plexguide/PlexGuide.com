#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

# FIRST QUESTION
question1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Cron - Schedule Cron Jobs (Backups) | $program?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://cron.pgblitz.com

[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    ansible-playbook /opt/plexguide/menu/cron/remove.yml && exit
  elif [ "$typed" == "2" ]; then
    break="on"
  else badinput; fi
}

# SECOND QUESTION
question2() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Cron - Backup How Often?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WEEKLY
0 - Sunday
[1] Monday
[2] Tuesday
[3] Wednesday
[4] Thursday
[5] Friday
[6] Saturday

DAILY
[7] Daily

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
  if [[ "$typed" -ge "0" && "$typed" -le "7" ]]; then
    echo $typed >/var/plexguide/cron/cron.day && break=1
  elif [ "$typed" == "8" ]; then
    echo "*/1" >/var/plexguide/cron/$program.cron.day && break=1
  else badinput; fi
}

# THIRD QUESTION
question3() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Cron - Hour of the Day?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type an HOUR from [0 to 23]

0  = 00:00 | 12AM
12 = 12:00 | 12PM
18 = 18:00 | 6 PM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type a Number | Press [ENTER]: ' typed </dev/tty
  if [[ "$typed" -ge "0" && "$typed" -le "23" ]]; then
    echo $typed >/var/plexguide/cron/cron.hour && break=1
  else badinput; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
break=off && while [ "$break" == "off" ]; do question2; done
break=off && while [ "$break" == "off" ]; do question3; done

echo $(($RANDOM % 59)) >/var/plexguide/cron/cron.minute
ansible-playbook /opt/plexguide/menu/cron/cron.yml
