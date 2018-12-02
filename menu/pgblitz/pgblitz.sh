#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

defaultvars () {
  touch /var/plexguide/rclone.gdrive
  touch /var/plexguide/rclone.gcrypt
}

deploykeys2 () {
a=b
}

deploykeys () {
  currentkeys=$(gcloud iam service-accounts list --filter="GDSA")
  gcloud iam service-accounts list --filter="GDSA" > /var/plexguide/gdsa.list
  cat /var/plexguide/gdsa.list | awk '{print $2}' | tail -n +2 > /var/plexguide/gdsa.cut
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: PG Key Generation Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$currentkeys

Keys listed above are the ones in current use! Proceeding onward will
delete the current keys and will generate new ones!

EOF

read -p '🌍 Build New Service Keys? | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "N" || "$typed" == "n" ]]; then keymenu;
elif [[ "$typed" == "Y" || "$typed" == "y" ]]; then deploykeys2;
else badinput && deploykeys; fi

}

projectid () {
gcloud projects list > /var/plexguide/projects.list
cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2 > /var/plexguide/project.cut
projectlist=$(cat /var/plexguide/project.cut)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Projects Interface Menu            📓 Reference: project.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$projectlist

EOF

read -p '🌍 Type EXACT Project Name to Utilize | Press [ENTER]: ' typed2 < /dev/tty
  list=$(cat /var/plexguide/project.cut | grep $typed2)
  if [ "$list" == "" ]; then
  badinput && projectid; fi
  gcloud config set project $typed2
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby - Enabling Your API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  gcloud services enable drive.googleapis.com --project $typed2
  echo $typed2 > /var/plexguide/project.final
echo
read -p '🌍 Process Complete | Press [ENTER] ' typed2 < /dev/tty

}

keymenu () {
gcloud info | grep Account: | cut -c 10- > /var/plexguide/project.account
account=$(cat /var/plexguide/project.account)
finalprojectid=$(cat /var/plexguide/project.final)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Blitz Key Generation             📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Log-In to Your Account      $account
2 - Build a New Project
3 - Establish Project ID        [$finalprojectid]
4 - Create/Remake Service Keys
Z - Exit

EOF

read -p '🌍 Type Number | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  gcloud auth login
  echo "[NOT SET]" > /var/plexguide/project.final
  keymenu
elif [ "$typed" == "2" ]; then
  date=`date +%m%d`
  rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
  projectid="pg-$date-$rand"
  gcloud projects create $projectid
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Confirm Info | Press [ENTER]: ' typed < /dev/tty
    keymenu
elif [ "$typed" == "3" ]; then

projectid
keymenu

elif [ "$typed" == "4" ]; then

deploykeys
keymenu

elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1; else badinput && keymenu; fi
}

badmenu () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Blitz                 📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Team Drives and the deployment is semi-complicated. If uploading
less than 750GB per day, utilize PG Move! Good luck!

NOTE: GDrive Must Be Configured (to backup your applications)

1 - Configure RClone
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

badtdrive () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Blitz                  📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Team Drives and the deployment is semi-complicated. If uploading
less than 750GB per day, utilize PG Move! Good luck!

$message

1 - Configure RClone
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

goodmenu () {
  if [[ "$gdstatus" == "good" && "$gcstatus" == "bad" ]]; then message="3 - Deploy PG Blitz: TDrive" && message2="Z - Exit" dstatus="1";
  elif [[ "$gdstatus" == "good" && "$gcstatus" == "good" ]]; then message="4 - Deploy PG Blitz: TDrive /w Encryption" && message2="Z - Exit" && dstatus="2";
  else message="Z - Exit" message2="" && dstatus="0"; fi

  # Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Blitz                  📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Team Drives and the deployment is semi-complicated. If uploading
less than 750GB per day, utilize PG Move! Good luck!

1 - Configure RClone
2 - Key Management [$keys Keys Exist]
3 - EMail Share Generator
$message
$message2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

question1 () {
readrcloneconfig

if [ "$gdstatus" == "bad" ]; then badmenu; fi

if [ "$tdstatus" == "semi" ]; then
message="NOTE: TDrive is Setup, but user failed to configure as a Team Drive! Must
reconfigure TDrive again and say 'Yes' and select a Team Drive!"
badtdrive
elif [ "$tdstatus" == "bad" ]; then
message="NOTE: TDrive is not setup! Required for PGBlitz's upload configuration!"
badtdrive
fi

if [[ "$tdstatus" == "good" && "$gdstatus" == "good" ]]; then goodmenu; fi

# Standby
read -p '🌍 Type Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo && readrcloneconfig && rcloneconfig && question1;
elif [ "$typed" == "2" ]; then keymenu && question1;
elif [ "$typed" == "3" ]; then removemounts;
    if [ "$dstatus" == "1" ]; then
    echo "gdrive" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  elif [ "$dstatus" == "2" ]; then
    echo "gcrypt" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/gcrypt.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  else question1; fi
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else
  badinput
  question1
fi
}

question1
