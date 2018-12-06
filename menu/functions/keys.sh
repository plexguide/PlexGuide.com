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

deletekeys2 () {
  choicedel=$(cat /var/plexguide/gdsa.cut)
  if [ "$choicedel" != "" ]; then
    echo ""
    echo "Deleting All Previous Service Accounts & Keys!"
    echo ""

    while read p; do
    gcloud iam service-accounts delete $p --quiet
    done </var/plexguide/gdsa.cut

  rm -rf /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Prior Service Accounts & Keys Deleted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
  keymenu
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: No Prior Service Accounts or Keys!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
  fi
question1
}

deletekeys () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: PG Key Gen Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
gcloud iam service-accounts list --filter="GDSA" > /var/plexguide/gdsa.list
cat /var/plexguide/gdsa.list | awk '{print $2}' | tail -n +2 > /var/plexguide/gdsa.cut
cat /var/plexguide/gdsa.cut
tee <<-EOF

Items listed are all service accounts that have been created! Proceeding
onward will destroy all service accounts and current keys!

EOF
read -p '🌍 Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "Y" || "$typed" == "y" ]]; then deletekeys2
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then question1
else
  badinput
  deletekeys
fi
}

gdsabuild () {
  downloadpath=$(cat /var/plexguide/server.hd.path)
  tempbuild=$(cat /var/plexguide/json.tempbuild)
  path=/opt/appdata/pgblitz/keys
  rpath=/opt/appdata/plexguide/rclone.conf
  tdrive=$( cat /opt/appdata/plexguide/rclone.conf | grep team_drive | head -n1 )
  tdrive="${tdrive:13}"
  ENCRYPTED="no"

  if [ -f "/opt/appdata/pgblitz/vars/encrypted" ]; then
      ENCRYPTED="yes"
      PASSWORD=`cat /opt/appdata/pgblitz/vars/password`
      SALT=`cat /opt/appdata/pgblitz/vars/salt`
      ENC_PASSWORD=`rclone obscure "$PASSWORD"`
      ENC_SALT=`rclone obscure "$SALT"`; fi

  echo "" >> $rpath
  #### Ensure to Backup TDrive & GDrive and Wipe the Rest
  #while read p; do

  ####tempbuild is need in order to call the correct gdsa
  mkdir -p $downloadpath/pgblitz/$tempbuild
  echo "[$tempbuild]" >> $rpath
  echo "type = drive" >> $rpath
  echo "client_id =" >> $rpath
  echo "client_secret =" >> $rpath
  echo "scope = drive" >> $rpath
  echo "root_folder_id =" >> $rpath
  echo "service_account_file = /opt/appdata/pgblitz/keys/processed/$tempbuild" >> $rpath
  echo "team_drive = $tdrive" >> $rpath

  if [ "$ENCRYPTED" == "yes" ]; then
      echo "" >> $rpath
      echo "[${tempbuild}C]" >> $rpath
      echo "type = crypt" >> $rpath
      echo "remote = $tempbuild:/encrypt" >> $rpath
      echo "filename_encryption = standard" >> $rpath
      echo "directory_name_encryption = true" >> $rpath
      echo "password = $ENC_PASSWORD" >> $rpath
      echo "password2 = $ENC_SALT" >> $rpath; fi
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
6 - Create 20 Keys: Daily Limit - 15   TB

NOTE: # of Keys Generated Sets Your Daily Upload Limit!

EOF
  read -p '🌍 Type Number? | Press [ENTER]: ' typed < /dev/tty

  echo ""
  echo "NOTE: Please Wait"
  echo ""
  if [ "$typed" == "1" ]; then echo "Creating 2 Keys - Daily Upload Limit Set to 1.5TB" && keys=2;
elif [ "$typed" == "2" ]; then echo "Creating 4 Keys - Daily Upload Limit Set to 3.0TB" && keys=4;
elif [ "$typed" == "3" ]; then echo "Creating 6 Keys - Daily Upload Limit Set to 4.5TB" && keys=6;
elif [ "$typed" == "4" ]; then echo "Creating 8 Keys - Daily Upload Limit Set to 6.0TB" && keys=8;
elif [ "$typed" == "5" ]; then echo "Creating 10 Keys - Daily Upload Limit Set to 7.5TB" && keys=10;
elif [ "$typed" == "6" ]; then echo "Creating 20 Keys - Daily Upload Limit Set to 15.0TB" && keys=20;
  fi
  sleep 2
  echo ""

  if [[ "$typed" -le "0" && "$typed" -ge 7 ]]; then deploykeys3; fi

  num=$keys
  count=0
  project=$(cat /var/plexguide/project.final)

  ##wipe previous keys stuck there
  mkdir -p /opt/appdata/pgblitz/keys/processed/
  rm -rf /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1

  ## purpose of the rewrite is to save gdrive and tdrive info and toss old GDSAs
      cat /opt/appdata/plexguide/rclone.conf | grep -w "\[tdrive\]" -A 5 > /opt/appdata/plexguide/tdrive.info
      cat /opt/appdata/plexguide/rclone.conf | grep -w "\[gdrive\]" -A 4 > /opt/appdata/plexguide/gdrive.info
      echo "#### rclone rewrite generated by plexguide.com" > /opt/appdata/plexguide/rclone.conf
      echo "" >> /opt/appdata/plexguide/rclone.conf
      echo "" >> /opt/appdata/plexguide/rclone.conf
      cat /opt/appdata/plexguide/gdrive.info >> /opt/appdata/plexguide/rclone.conf
      echo "" >> /opt/appdata/plexguide/rclone.conf
      cat /opt/appdata/plexguide/tdrive.info >> /opt/appdata/plexguide/rclone.conf

    while [ "$count" != "$keys" ]; do
    ((count++))
    rand=$(echo $((1 + RANDOM * RANDOM)))

    if [ "$count" -ge 1 -a "$count" -le 9 ]; then
      gcloud iam service-accounts create gdsa$rand --display-name “gdsa0$count”
      gcloud iam service-accounts keys create /opt/appdata/pgblitz/keys/processed/gdsa0$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
      echo "gdsa0$count" > /var/plexguide/json.tempbuild
      gdsabuild
      echo ""
    else
      gcloud iam service-accounts create gdsa$rand --display-name “gdsa$count”
      gcloud iam service-accounts keys create /opt/appdata/pgblitz/keys/processed/gdsa$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
      echo "gdsa$count" > /var/plexguide/json.tempbuild
      gdsabuild
      echo ""
    fi
    done

  echo "no" > /var/plexguide/project.deployed

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Key Generation Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Do not forget to use the email generator and share the emails to
your teamdrives! If you forget, you will be wondering why stuff does not
work!

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
}

deploykeys2 () {
deploykeys3
}

deploykeys () {
  gcloud iam service-accounts list --filter="GDSA" > /var/plexguide/gdsa.list
  cat /var/plexguide/gdsa.list | awk '{print $2}' | tail -n +2 > /var/plexguide/gdsa.cut
deploykeys2
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
ufsbuilder () {
  downloadpath=$(cat /var/plexguide/server.hd.path)
  ls -la /opt/appdata/pgblitz/keys/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa.ufs
  rm -rf /tmp/pg.gdsa.build 1>/dev/null 2>&1
  #echo -n "/mnt/tdrive=RO:" > /tmp/pg.gdsa.build
  #echo -n "/mnt/gdrive=RO:" >> /tmp/pg.gdsa.build
  ##### Encryption Portion ### Start
  #tcrypt=$(grep "tcrypt" /opt/appdata/plexguide/rclone.conf)
  #gcrypt=$(grep "gcrypt" /opt/appdata/plexguide/rclone.conf)

  #if [ "$tcrypt" == "[tcrypt]" ]  && [ "$gcrypt" == "[gcrypt]" ]; then
  #    encryption="on"
  #  else
      encryption="off"
  #fi

  #if [ "$encryption" == "on" ]; then
  #  echo -n "/mnt/gcrypt=RO:" >> /tmp/pg.gdsa.build
  #fi
  ##### Encryption Portion ### END
  file="/var/plexguide/unionfs.pgpath"
  if [ -e "$file" ]; then rm -r /var/plexguide/unionfs.pgpath && touch /var/plexguide/unionfs.pgpath; fi

  while read p; do
  mkdir -p $downloadpath/pgblitz/$p
  echo -n "$downloadpath/pgblitz/$p=RO:" >> /var/plexguide/unionfs.pgpath
  done </tmp/pg.gdsa.ufs
  builder=$(cat /var/plexguide/unionfs.pgpath)
  }

rchecker () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Conducting RClone Validation Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Creating Test Directory - gdsa01:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone mkdir --config /opt/appdata/plexguide/rclone.conf gdsa01:/plexguide
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: Checking Existance of gdsa01:/plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/appdata/plexguide/rclone.conf gdsa01: | grep -oP plexguide | head -n1)

  if [ "$rcheck" != "plexguide" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: RClone Validation Check Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you share the email address to the correct team drive?
2. Does the user login of the GDSA keys match the shared team drive?
3. Make your corrections and redeploy again!

EOF
    echo no > /var/plexguide/project.deployed
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  fi
}


pgbdeploy () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Messasge: PG Blitz Deployed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
}

keymenu () {
gcloud info | grep Account: | cut -c 10- > /var/plexguide/project.account
account=$(cat /var/plexguide/project.account)
finalprojectid=$(cat /var/plexguide/project.final)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Blitz Key Generation             📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Make Service Keys
Z - Exit
A - Destory all Service Accounts Created

EOF

read -p '🌍 Type Number | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  deploykeys
  keymenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  question1
elif [[ "$typed" == "A" || "$typed" == "a" ]]; then
  deletekeys
  keymenu
else
  badinput
  keymenu; fi
}
