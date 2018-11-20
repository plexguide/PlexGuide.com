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
################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty

}

# FIRST QUESTION
question1 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Cron - Schedule Cron Jobs (Backups) for $program?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://cron.plexguide.com

1 - No
2 - Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then ansible-playbook /opt/plexguide/menu/cron/remove.yml && exit;
elif [ "$typed" == "2" ]; then break="on";
else badinput; fi
}

# SECOND QUESTION
question2 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Cron - How Often Do You Wish To Backup?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WEEKLEY
0 - Sunday
1 - Monday
2 - Tuesday
3 - Wednesday
4 - Thursday
5 - Friday
6 - Saturday

DAILY
7 - Daily

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "0" && "$typed" -le "7" ]]; then echo $typed > /var/plexguide/cron/cron.day && break=1;
elif [ "$typed" == "8" ]; then echo "*/1" > /var/plexguide/cron/$program.cron.day && break=1;
else badinput; fi
}

# THIRD QUESTION
question3 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Cron - What Hour of the Day?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type an HOUR from [0 to 23]

0  = 00:00 | 12AM
12 = 12:00 | 12PM
18 = 18:00 | 6 PM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "0" && "$typed" -le "23" ]]; then echo $typed > /var/plexguide/cron/cron.hour && break=1;
else badinput; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
break=off && while [ "$break" == "off" ]; do question2; done
break=off && while [ "$break" == "off" ]; do question3; done

echo $(($RANDOM % 59)) > /var/plexguide/cron/cron.minute
ansible-playbook /opt/plexguide/menu/cron/cron.yml

#serverip=$(cat /opt/appdata/plexguide/server.info | tail -n +3 | head -n 1 | cut -d " " -f2-)
#initialpw=$(cat /opt/appdata/plexguide/server.info | tail -n +4 | cut -d " " -f3-)
#check=$(hcloud server list | grep "\<$sshin\>" | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
#ipcheck=$(echo $check | awk '{ print $3 }')
#⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
# read -n 1 -s -r -p "Press [ANY] Key to Continue "
