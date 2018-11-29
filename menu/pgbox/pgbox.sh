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

# FUNCTIONS START ##############################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
question1
}

# FIRST QUESTION

question1 () {

rm -r /var/plexguide/pgbox.running
rm -r /var/plexguide/programs.temp

bash /opt/plexguide/containers/_appsgen.sh
docker ps | awk '{print $NF}' | tail -n +2 > /var/plexguide/pgbox.running

while read p; do
  sed -i -e "/$p/d" /var/plexguide/app.list
done </var/plexguide/pgbox.running

while read p; do
  echo -n $p >> /var/plexguide/program.temp
  echo -n " " >> /var/plexguide/program.app
  num=$[num+1]
  if [ $num == 7 ]; then
    num=0
    echo " " >> /var/plexguide/programs.app
  fi
done </var/plexguide/app.list

running=$(cat /var/plexguide/program.temp)

tee <<-EOF

📂 PG Apps - Not Installed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://pgbox.plexguide.com

$running

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p 'Make a Selection | Press [ENTER]: ' typed < /dev/tty
echo

  if [ "$typed" == "1" ]; then
    read -p 'Enter the PLEX User Name | Press [ENTER]: ' user < /dev/tty
    read -p 'Enter the PLEX User Pass | Press [ENTER]: ' pw < /dev/tty

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Saved Your Information!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
question2
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then exit;
else badinput; fi
}

question2 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG - User Name & PassWord Confirmation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://plextoken.plexguide.com

User Name: $user
User Pass: $pw

⚠️  Information Correct?

1 - YES
2 - NO
Z - Exit Interface

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p 'Make a Selection | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖 NOM NOM - Got It! Generating the Plex Token!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If the token is bad, this process will repeat again!

EOF
sleep 4
question3
elif [ "$typed" == "2" ]; then question1;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then exit;
else badinput2; fi
}

question3 () {
echo "$pw" > /var/plexguide/plex.pw
echo "$user" > /var/plexguide/plex.user
ansible-playbook /opt/plexguide/menu/plex/token.yml
token=$(cat /var/plexguide/plex.token)
  if [ "$token" != "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PG - PlexToken Generation Succeeded!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 4
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  PG - PlexToken Generation Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Process will repeat until you succeed or exit!

EOF
  read -p 'Confirm Info | Press [ENTER] ' typed < /dev/tty
  question1
  fi
}

# FUNCTIONS END ##############################################################

question1
