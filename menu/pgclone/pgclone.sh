#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

initial () {
  rolename='pgclone'
  mkdir -p "/opt/$rolename"
  ansible-playbook "/opt/plexguide/menu/$rolename/$rolename.yml"

  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/opt/pgclone/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
}

custom () {
  rolename='pgclone'
  mkdir -p "/opt/$rolename"
  ansible-playbook "/opt/plexguide/menu/$rolename/${rolename}_personal.yml"

  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/opt/pgclone/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
}

mainbanner () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone                            📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 PG Clone is a combined group of services that utilizes PG Blitz and
PG Move in conjuction with RClone and automations to mount data drives
and transfer data in a hasty manner!

[1] Utilize PG Clone - PlexGuide's
[2] Utilize PG Clone - Personal (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        initial ;;
    2 )
        variable /var/plexguide/pgclone.user "NOT-SET"
        variable /var/plexguide/pgclone.branch "NOT-SET"
        pinterface ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

pinterface () {

cloneuser=$(cat /var/plexguide/pgclone.user)
clonebranch=$(cat /var/plexguide/pgclone.branch)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone!                             📓 Reference: clone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 User: $cloneuser | Branch: $clonebranch

[1] Change User Name & Branch
[2] Deploy PG Clone - Personal (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 IMPORTANT MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Username & Branch are both case sensitive! Normal default branch is v8.0,
but check the branch under your fork that is being pulled!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -p 'Username | Press [ENTER]: ' cloneuser < /dev/tty
        read -p 'Branch   | Press [ENTER]: ' clonebranch < /dev/tty
        echo "$cloneuser" > /var/plexguide/pgclone.user
        echo "$clonebranch" > /var/plexguide/pgclone.branch
        pinterface ;;
    2 )
        existcheck=$(git ls-remote --exit-code -h "https://github.com/$cloneuser/PlexGuide-PGClone" | grep "$clonebranch")
        if [ "$existcheck" == "" ]; then echo;
        read -p '💬 Exiting! Forked Version Does Not Exist! | Press [ENTER]: ' typed < /dev/tty
        mainbanner; fi
        custom ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

# FUNCTIONS END ##############################################################
echo "" > /tmp/output.info
mainbanner
