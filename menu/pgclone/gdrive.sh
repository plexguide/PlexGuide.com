#!/bin/bash
#
# Title:      PGClone (A 100% PG Product)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/keys.sh
source /opt/plexguide/menu/functions/keyback.sh
source /opt/plexguide/menu/functions/pgclone.sh
################################################################################
question1 () {
  touch /opt/appdata/plexguide/rclone.conf
  account=$(cat /var/plexguide/project.account)
  project=$(cat /var/plexguide/pgclone.project)
  project=$(cat /var/plexguide/pgclone.transport)
  gstatus=$(cat /var/plexguide/gdrive.pgclone)
  tstatus=$(cat /var/plexguide/tdrive.pgclone)
  transportdisplay

#  if [ "$temp" == "umove" ]; then transport="PG Move /w No Encryption"
#elif [ "$temp" == "emove" ]; then transport="PG Move /w Encryption"
#elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"

if [[ "$transport" == "PG Move /w No Encryption" || "$transport" == "PG Move /w Encryption" ]]; then menufix=1; else menufix=2; fi

if [ "$menufix" == "1" ]; then
display1="5 - Deploy ~ $transport"
a=9999999; fi
if [ "$menufix" == "2" ]; then
display1="5 - Key Management      : [keysdeployed]
6 - Deploy ~ $transport"
a=6; fi

if [ "$account" == "NOT-SET" ]; then
  display5="[NOT-SET]"
else
  display5="$account"; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PG Clone                     reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Data Transport Mode : [$transport]
2 - Google Account Login: $display5
3 - Project Options     : [$project]
4 - Mount Management    : [good/bad]
$display1
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 Type Selection | Press [ENTER] ' typed < /dev/tty

  if [ "$menufix" == "2" ]; then
    if [ "$typed" == "5" ]; then
      keymenu
      question1
    elif [ "$typed" == "6" ]; then
      removemounts
      ansible-playbook /opt/plexguide/menu/pgclone/gdrive.yml
      ansible-playbook /opt/plexguide/menu/pgclone/gcrypt.yml
      ansible-playbook /opt/plexguide/menu/pgclone/munionfs.yml
      ansible-playbook /opt/plexguide/menu/pgclone/pgmove.yml
      pgbdeploy
      question1
    fi
  fi

  if [ "$typed" == "1" ]; then
  transportmode
  question1
elif [ "$typed" == "2" ]; then
  gcloud auth login
  echo "NOT SET" > /var/plexguide/pgclone.project
  question1
elif [ "$typed" == "3" ]; then
  projectmenu
  question1
elif [ "$typed" == "4" ]; then
  mountsmenu
  question1
elif [ "$typed" == "5" ]; then
  if [ "$menufix" == "1" ]; then
    if [ "$transport" == "PG Move /w No Encryption" ]; then
      echo "gdrive" > /var/plexguide/rclone/deploy.version
      removemounts
      ansible-playbook /opt/plexguide/menu/pgclone/gdrive.yml
      ansible-playbook /opt/plexguide/menu/pgclone/munionfs.yml
      ansible-playbook /opt/plexguide/menu/pgclone/pgmove.yml
      pgbdeploy
      question1
    fi
    if [ "$transport" == "PG Move /w Encryption" ]; then
      echo "gcrypt" > /var/plexguide/rclone/deploy.version
      removemounts
      ansible-playbook /opt/plexguide/menu/pgclone/gdrive.yml
      ansible-playbook /opt/plexguide/menu/pgclone/gcrypt.yml
      ansible-playbook /opt/plexguide/menu/pgclone/munionfs.yml
      ansible-playbook /opt/plexguide/menu/pgclone/pgmove.yml
      pgbdeploy
      question1
    fi
  else
  question1
  fi
elif [ "$typed" == "$a" ]; then
  question1
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  exit
else
  badinput
  keymenu; fi
#menu later
inputphase
}
# Reminder for gdrive/tdrive / check rclone to set if active, below just placeholder
variable /var/plexguide/project.account "NOT-SET"
variable /var/plexguide/pgclone.project "NOT-SET"
variable /var/plexguide/pgclone.teamdrive ""
variable /var/plexguide/pgclone.public ""
variable /var/plexguide/pgclone.secret ""
variable /var/plexguide/pgclone.transport "NOT-SET"
variable /var/plexguide/gdrive.pgclone "Not Active"
variable /var/plexguide/tdrive.pgclone "Not Active"

question1

#date=`date +%m%d`
#rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
#projectid="pg-$date-$rand"
#gcloud projects create $projectid
#sleep 1
