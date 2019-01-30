#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
bandwidth () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: BW Limit Notice        📓 Reference: move.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 10MB is a safe limit. If exceeding 10MB and uploading straight for
24 hours, an upload ban will be triggered.

EOF
  read -p '↘️  Type a Speed from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "1000" ]]; then echo "$typed" > /var/plexguide/move.bw && question1;
  else badinput && bandwidth; fi
}

bandwidthblitz () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: BW Limit Notice        📓 Reference: move.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 100MB = 1 Gig Speeds | 1000MB = 10 Gig Speeds - Remember that your
   upload speeds are still limited to your server's max upload connection

EOF
  read -p '↘️  Type a Speed from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "1000" ]]; then echo "$typed" > /var/plexguide/blitz.bw && question1;
  else badinput && bandwidth; fi
}

statusmount () {
  mcheck5=$(cat /opt/appdata/plexguide/rclone.conf | grep "$type")
  if [ "$mcheck5" != "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  System Message: Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: $type already exists! To proceed, we must delete the prior
configuration for you.

EOF
  read -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then mountsmenu
  else
    badinput
    statusmount
  fi

  rclone config delete $type --config /opt/appdata/plexguide/rclone.conf

  encheck=$(cat /var/plexguide/pgclone.transport)
  if [[ "$encheck" == "eblitz" || "$encheck" == "emove" ]]; then
    if [ "$type" == "gdrive" ]; then
    rclone config delete gcrypt --config /opt/appdata/plexguide/rclone.conf; fi
    if [ "$type" == "tdrive" ]; then
    rclone config delete tcrypt --config /opt/appdata/plexguide/rclone.conf; fi
  fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: $type deleted!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
fi
}

tmgen() {

secret=$(cat /var/plexguide/pgclone.secret)
public=$(cat /var/plexguide/pgclone.public)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - Team Drives           📓 Reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /var/plexguide/pgtokentm.output
  cat /var/plexguide/pgtokentm.output | grep access_token | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /var/plexguide/pgtokentm2.output
  primet=$(cat /var/plexguide/pgtokentm2.output)
  curl -H "GData-Version: 3.0" -H "Authorization: Bearer $primet" https://www.googleapis.com/drive/v3/teamdrives > /var/plexguide/teamdrive.output
  tokenscript

  name=$(sed -n ${typed}p /var/plexguide/teamdrive.name)
  id=$(sed -n ${typed}p /var/plexguide/teamdrive.id)
echo "$name" > /var/plexguide/pgclone.teamdrive
echo "$id" > /var/plexguide/pgclone.teamid
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
😂 What a Lame TeamDrive Name: $name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | PRESS [ENTER] ' temp < /dev/tty
}

tokenscript () {
  cat /var/plexguide/teamdrive.output | grep "id" | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /var/plexguide/teamdrive.id
  cat /var/plexguide/teamdrive.output | grep "name" | awk '{ print $2 }' | cut -c2- | rev | cut -c2- | rev > /var/plexguide/teamdrive.name

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Listed Team Drives
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  A=0
  while read p; do
  ((A++))
  name=$(sed -n ${A}p /var/plexguide/teamdrive.name)
  echo "[$A] $p - $name"
done </var/plexguide/teamdrive.id

echo ""
read -p '↘️  Type Number | PRESS [ENTER]: ' typed < /dev/tty
if [[ "$typed" -ge "1" && "$typed" -le "$A" ]]; then a=b
else
  badinput
  tokenscript; fi
}

inputphase () {
deploychecks

if [[ "$transport" == "PG Move /w No Encryption" || "$transport" == "PG Move /w Encryption" ]]; then
  display=""
else
  if [ "$type" == "tdrive" ]; then
  display="TEAMDRIVE: $teamdrive
  ";fi; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: PG Clone - $type     📓 Reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 PG is Deploying /w the Following Values:

🌅 ID
$public

💎 SECRET
$secret
$display
EOF

read -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then question1
else
  badinput
  inputphase
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Auth          📓 Reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/appdata/plexguide/pgclone.info

  accesstoken=$(cat /opt/appdata/plexguide/pgclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/appdata/plexguide/pgclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

mountsmenu () {

# Sets Display Status if Passwords are not set for the encryhpted edition
check5=$(cat /var/plexguide/pgclone.password)
check6=$(cat /var/plexguide/pgclone.salt)
if [[ "$check5" == "" || "$check6" == "" ]]; then passdisplay="⚠️  Not Activated"
else passdisplay="✅ Activated"; fi

projectid=$(cat /var/plexguide/pgclone.project)
secret=$(cat /var/plexguide/pgclone.secret)
public=$(cat /var/plexguide/pgclone.public)
teamdrive=$(cat /var/plexguide/pgclone.teamdrive)

if [ "$secret" == "" ]; then dsecret="NOT SET"; else dsecret="SET"; fi
if [ "$public" == "" ]; then dpublic="NOT SET"; else dpublic="SET"; fi
if [ "$teamdrive" == "" ]; then dteamdrive="NOT SET"; else dteamdrive=$teamdrive; fi

gstatus=$(cat /var/plexguide/gdrive.pgclone)
tstatus=$(cat /var/plexguide/tdrive.pgclone)

###### START
if [ "$transport" == "PG Move /w No Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

📁 RClone Configuration
[3] gdrive   : $gstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    publickeyinput
    mountsmenu
  elif [ "$typed" == "2" ]; then
    secretkeyinput
    mountsmenu
  elif [ "$typed" == "3" ]; then
    type=gdrive
    statusmount
    inputphase
    mountsmenu
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
  else badinput
    mountsmenu; fi
fi
########## END

########## START
if [ "$transport" == "PG Move /w Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] Passwords: $passdisplay

📁 RClone Configuration
[4] gdrive   : $gstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    publickeyinput
    mountsmenu
  elif [ "$typed" == "2" ]; then
    secretkeyinput
    mountsmenu
  elif [ "$typed" == "3" ]; then
    blitzpasswords
    mountsmenu
  elif [ "$typed" == "4" ]; then
    encpasswdcheck
    type=gdrive
    statusmount
    inputphase
    mountsmenu
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
  else badinput
    mountsmenu; fi
fi
###### END

###### START
if [ "$transport" == "PG Blitz /w No Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive

📁 RClone Configuration
[4] gdrive   : $gstatus
[5] tdrive   : $tstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  publickeyinput
  mountsmenu
elif [ "$typed" == "2" ]; then
  secretkeyinput
  mountsmenu
elif [ "$typed" == "3" ]; then
  tmgen
  mountsmenu
elif [ "$typed" == "4" ]; then
  type=gdrive
  statusmount
  inputphase
  mountsmenu
elif [ "$typed" == "5" ]; then
  tmcheck=$(cat /var/plexguide/pgclone.teamdrive)
  if [ "$tmcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
  type=tdrive
  statusmount
  inputphase
  mountsmenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else badinput
  mountsmenu; fi
fi
#################### END

##### START
if [ "$transport" == "PG Blitz /w Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive
[4] Passwords: $passdisplay

📁 RClone Configuration
[5] gdrive   : $gstatus
[6] tdrive   : $tstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  publickeyinput
  mountsmenu
elif [ "$typed" == "2" ]; then
  secretkeyinput
  mountsmenu
elif [ "$typed" == "3" ]; then
  tmgen
  mountsmenu
elif [ "$typed" == "4" ]; then
  blitzpasswords
  mountsmenu
elif [ "$typed" == "5" ]; then
  encpasswdcheck
  type=gdrive
  statusmount
  inputphase
  mountsmenu
elif [ "$typed" == "6" ]; then
  encpasswdcheck
  tmcheck=$(cat /var/plexguide/pgclone.teamdrive)
  if [ "$tmcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
  type=tdrive
  statusmount
  inputphase
  mountsmenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else badinput
  mountsmenu; fi
fi
#################### END

}

encpasswdcheck () {
check5=$(cat /var/plexguide/pgclone.password)
check6=$(cat /var/plexguide/pgclone.salt)

if [[ "$check5" == "" || "$check6" == "" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! You Need to Setup Your Passwords for the Encrypted Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
}

blitzpasswords () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Primary Password                   📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Please set a Primary Password for Encryption! Do not forget it! If you do,
you will be locked out from all your data!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p ' ↘️  Type Prime PW | Press [ENTER]: ' bpassword < /dev/tty

if [ "$bpassword" == "" ]; then
  badinput
  blitzpasswords
elif [ "$bpassword" == "exit" ]; then mountsmenu; fi
blitzsalt
}

blitzsalt () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 SALT (Secondary Password)          📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Please set a Secondary Password (SALT) for Encryption! Do not forget it!
If you do, you will be locked out from all your data!  SALT randomizes
your data to further protect you! It is not recommended to use the same
password, but may.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p ' ↘️  Type SALT PW | Press [ENTER]: ' bsalt < /dev/tty

if [ "$bsalt" == "" ]; then
  badinput
  blitzsalt
elif [ "$bsalt" == "exit" ]; then mountsmenu; fi
blitzpfinal

}

blitzpfinal () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Set Passwords?                     📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Are you happy with the following info? Type y or n!

Primary  : $bpassword
Secondary: $bsalt

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Type y or n | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "n" ]; then mountsmenu;
elif [ "$typed" == "y" ]; then
echo $bpassword > /var/plexguide/pgclone.password
echo $bsalt > /var/plexguide/pgclone.salt
mountsmenu;
else
  badinput
  blitzpfinal; fi
}

publickeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Client ID        📓 Reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF

read -p '↘️  Client ID  | Press [Enter]: ' public < /dev/tty
if [ "$public" = "exit" ]; then mountsmenu; fi
echo "$public" > /var/plexguide/pgclone.public

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Client ID Set                      📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty
mountsmenu
}

secretkeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Secret Key       📓 Reference: oauth.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF
read -p '↘️  Secret Key  | Press [Enter]: ' secret < /dev/tty
if [ "$secret" = "exit" ]; then mountsmenu; fi
echo "$secret" > /var/plexguide/pgclone.secret

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Secret ID Set                       📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty

mountsmenu
}

projectmenu () {
projectid=$(cat /var/plexguide/pgclone.project)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface           📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

[1] Establish
[2] Create
[3] Destroy (NOT READY)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

if [ "$typed" == "1" ]; then projectestablish;
elif [ "$typed" == "2" ]; then projectcreate;
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then question1;
else badinput
  projectmenu; fi
}

projectcreate () {
  date=`date +%m%d`
rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
projectid="pg-$date-$rand"
gcloud projects create $projectid
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Confirm Info | Press [ENTER]: ' typed < /dev/tty
keymenu
}

projectestablish () {

  gcloud projects list > /var/plexguide/projects.list
  projectcheck=(cat /var/plexguide/projects.list)
  if [ "$projectcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! There are no projects! Make one first!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectmenu
fi


tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Established Projects               📓 Reference: pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

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
  echo $typed > /var/plexguide/pgclone.project
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectmenu

}

transportdisplay () {
temp=$(cat /var/plexguide/pgclone.transport)
  if [ "$temp" == "umove" ]; then transport="PG Move /w No Encryption"
elif [ "$temp" == "emove" ]; then transport="PG Move /w Encryption"
elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"
elif [ "$temp" == "eblitz" ]; then transport="PG Blitz /w Encryption"
else transport="NOT-SET"; fi
}

transportmode () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 Select Transport Mode            📓 Reference: transport.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] PG Move  /w No Encryption | Upload 750GB Daily ~ Simple
[2] PG Move  /w Encryption    | Upload 750GB Daily ~ Simple
[3] PG Blitz /w No Encryption | Exceed 750GB Daily ~ Complex
[4] PG Blitz /w Encryption    | Exceed 750GB Daily ~ Complex
[Z] Exit

EOF
read -p '↘️  Set Choice | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo "umove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "2" ]; then echo "emove" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "3" ]; then echo "ublitz" > /var/plexguide/pgclone.transport && echo;
elif [ "$typed" == "4" ]; then echo "eblitz" > /var/plexguide/pgclone.transport && echo;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else
  badinput
  transportmode; fi
}

changeproject () {
  read -p '💬 Set/Change Project ID? (y/n)| Press [ENTER] ' typed < /dev/tty
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
  cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2 > /var/plexguide/project.cut
  echo ""
  read -p '↘️  Type Project Name | Press [ENTER]: ' typed < /dev/tty
  echo ""
  list=$(cat /var/plexguide/project.cut | grep $typed)

  if [ "$typed" != "$list" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! Type Exact of the Project Name Listed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectidset
  fi
}

testphase () {
  echo "" > /opt/appdata/plexguide/test.conf
  echo "[$type]" >> /opt/appdata/plexguide/test.conf
  echo "client_id = $public" >> /opt/appdata/plexguide/test.conf
  echo "client_secret = $secret" >> /opt/appdata/plexguide/test.conf
  echo "type = drive" >> /opt/appdata/plexguide/test.conf
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /opt/appdata/plexguide/test.conf
  echo "" >> /opt/appdata/plexguide/test.conf
  if [ "$type" == "tdrive" ]; then
  teamid=$(cat /var/plexguide/pgclone.teamid)
  echo "team_drive = $teamid" >> /opt/appdata/plexguide/test.conf; fi
  echo ""

## Adds Encryption to the Test Phase if Move or Blitz Encrypted is On
encheck=$(cat /var/plexguide/pgclone.transport)
if [[ "$encheck" == "eblitz" || "$encheck" == "emove" ]]; then

  if [ "$type" == "gdrive" ]; then entype="gcrypt";
  else entype="tcrypt"; fi

  PASSWORD=`cat /var/plexguide/pgclone.password`
  SALT=`cat /var/plexguide/pgclone.salt`
  ENC_PASSWORD=`rclone obscure "$PASSWORD"`
  ENC_SALT=`rclone obscure "$SALT"`
  echo "" >> /opt/appdata/plexguide/test.conf
  echo "[$entype]" >> /opt/appdata/plexguide/test.conf
  echo "type = crypt" >> /opt/appdata/plexguide/test.conf
  echo "remote = $type:/encrypt" >> /opt/appdata/plexguide/test.conf
  echo "filename_encryption = standard" >> /opt/appdata/plexguide/test.conf
  echo "directory_name_encryption = true" >> /opt/appdata/plexguide/test.conf
  echo "password = $ENC_PASSWORD" >> /opt/appdata/plexguide/test.conf
  echo "password2 = $ENC_SALT" >> /opt/appdata/plexguide/test.conf;

fi
testphase2
}

testphase2 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting Validation Checks - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - $type:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone mkdir --config /opt/appdata/plexguide/test.conf $type:/plexguide
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/appdata/plexguide/test.conf $type: | grep -oP plexguide | head -n1)

  if [ "$rcheck" != "plexguide" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Deleting Test Directory - $type:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone rmdir $type:/plexguide
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you copy your username and password correctly?
2. When you created the credentials, did you select "Other"?
3. Did you enable your API?

FOR ENCRYPTION (IF SELECTED)
1. Did You Set a Password?

EOF
    echo "⚠️  Not Activated" > /var/plexguide/$type.pgclone
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

fi

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
echo "✅ Activated" > /var/plexguide/$type.pgclone

## Copy the Test File to the Real RClone Conf
cat /opt/appdata/plexguide/test.conf >> /opt/appdata/plexguide/rclone.conf

## Back to the Main Mount Menu
mountsmenu

EOF
}

deploychecks () {
secret=$(cat /var/plexguide/pgclone.secret)
public=$(cat /var/plexguide/pgclone.public)
teamdrive=$(cat /var/plexguide/pgclone.teamdrive)

if [ "$secret" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Secret Key Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi

if [ "$public" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Client ID Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi
}
