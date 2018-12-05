#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

mountsmenu () {
projectid=$(cat /var/plexguide/pgclone.project)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - Mounts                       reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

1 - Configure - gdrive  : [$gstatus]
2 - Configure - tdrive  : [$tstatus]
3 - Encryption Setup
4 - Exit

EOF

read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  type=gdrive
  inputphase
  mountsmenu
elif [ "$typed" == "2" ]; then
  type=tdrive
  inputphase
  mountsmenu

elif [ "$typed" == "4" ]; then question1;
else badinput
  projectmenu; fi
}

projectmenu () {
projectid=$(cat /var/plexguide/pgclone.project)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface               reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

1 - Establish
2 - Create
3 - Destroy (NOT READY)
4 - Exit

EOF

read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then projectestablish;
elif [ "$typed" == "2" ]; then projectcreate;
elif [ "$typed" == "4" ]; then question1;
else badinput
  projectmenu; fi
}

projectestablish () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface               reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

Established Projects
EOF
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2 > /var/plexguide/project.cut
  echo
  changeproject
  echo
  projectidset
  gcloud config set project $typed

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Enabling Drive API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
gcloud services enable drive.googleapis.com --project $typed
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Project Established ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  $typed > /var/plexguide/pgclone.project
  question1
]
}

transportdisplay () {
temp=$(cat /var/plexguide/pgclone.transport)
  if [ "$temp" == "umove" ]; then transport="PG Move ~ /w No Encryption"
elif [ "$temp" == "emove" ]; then transport="PG Move ~ /w Encryption"
elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"
else transport="NOT-SET"; fi
}

transportmode () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Select a Data Transport Mode          reference:transport.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - PG Move : Unencrypt | Simple  ~ Uploads 750GB  Per Day
2 - PG Move : Encrypted | Simple  ~ Uploads 750GB  Per Day
3 - PG Blitz: Unencrypt | Complex ~ Exceeds 750GB+ Per Day
Z - Exit

EOF
read -p '🌍 Set Choice | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo "umove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "2" ]; then echo "emove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "3" ]; then echo "ublitz" > /var/plexguide/pgclone.transport && echo;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else
  badinput
  transportmode; fi
}

changeproject () {
  read -p '🌍 Set/Change Project ID? (y/n)| Press [ENTER] ' typed < /dev/tty
  if [[ "$typed" == "n" || "$typed" == "N" ]]; then question1
elif [[ "$typed" == "y" || "$typed" == "Y" ]]; then a=b
else badinput
  echo ""
  changeproject; fi
}

projectidset () {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Type the Project Name to Utilize
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2
  echo ""
  read -p '🌍 Type Project Name | Press [ENTER]: ' typed < /dev/tty
  echo ""
  list=$(cat /var/plexguide/project.cut | grep $typed)

  if [ "$typed" != "$list" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Error! Type the Exact Project Name Listed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectidset
  fi
}

testphase () {
  echo "" > /opt/appdata/plexguide/test.conf
  echo "[gdrive]" >> /opt/appdata/plexguide/test.conf
  echo "client_id = $public" >> /opt/appdata/plexguide/test.conf
  echo "client_secret = $secret" >> /opt/appdata/plexguide/test.conf
  echo "type = drive" >> /opt/appdata/plexguide/test.conf
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /opt/appdata/plexguide/test.conf
  if [ "$type" == "tdrive" ]; then echo "team_drive = $teamdrive" >> /opt/appdata/plexguide/test.conf; fi
  echo ""
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Conducting GDrive Validation Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Creating Test Directory - gdrive:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone mkdir --config /opt/appdata/plexguide/test.conf gdrive:/plexguide
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Checking Existance of gdsa01:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/appdata/plexguide/test.conf gdrive: | grep -oP plexguide | head -n1)

  if [ "$rcheck" != "plexguide" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you copy your username and password correctly?
2. When you created the credentials, did you select "Other"?
3. Did you enable your API?

EOF
    echo "Not Active" > /var/plexguide/gdrive.pgclone
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Validation Checks Passed - GDrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

fi

echo "Active" > /var/plexguide/gdrive.pgclone
echo ""
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
question1

EOF
}
