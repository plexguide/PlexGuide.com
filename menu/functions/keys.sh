#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################


defaultvars () {
  touch /var/plexguide/rclone.gdrive
  touch /var/plexguide/rclone.gcrypt
}

deploykeys3 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Key Number Selection!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Create 2 Keys:  Daily Limit - 1.5  TB
2 - Create 4 Keys:  Daily Limit - 3.0  TB
3 - Create 6 Keys:  Daily Limit - 4.5  TB  <--- Realistic
4 - Create 8 Keys:  Daily Limit - 6.0  TB
5 - Create 10 Keys: Daily Limit - 7.5  TB
6 - Create 10 Keys: Daily Limit - 7.5  TB

NOTE: # of Keys Generated Sets Your Daily Upload Limit!

EOF
  read -p '🌍 Type Number? | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -le "0" && "$typed" -ge 7 ]]; then deploykeys3; fi
}

deploykeys2 () {
  choicedel=$(cat /var/plexguide/gdsa.cut)
  if [ "$choicedel" != "" ]; then
  echo "Deleting All Previous Keys!"
  echo ""
    while read p; do
    gcloud iam service-accounts delete $p --quiet
    done </var/plexguide/gdsa.cut
  rm -rf /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Prior Service Accounts Deleted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: No Prior Service Keys!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
fi

deploykeys3
}

deploykeys () {

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: PG Key Generation Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
currentkeys=$(gcloud iam service-accounts list --filter="GDSA")
gcloud iam service-accounts list --filter="GDSA" > /var/plexguide/gdsa.list
tee <<-EOF

Keys listed above are the ones in current use! Proceeding onward will
delete the current keys and will generate new ones!

EOF
read -p '🌍 Build New Service Keys? y or n | Press [ENTER]: ' typed < /dev/tty

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
