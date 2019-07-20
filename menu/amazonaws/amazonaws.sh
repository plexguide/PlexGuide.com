#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
test=$(hcloud server list)
if [ "$test" == "" ]; then

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - You Must Input an API from Hetzner First!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://hcloud.pgblitz.com

* Activate a Hetzner Cloud Account and Create a Project
* Click Access (left hand side) and then click API Tokens
* Create a Token and Save It (and paste below here)
* Not Ready? Just Something & Press [ENTER]

EOF
  hcloud context create plexguide

  test=$(hcloud server list)
  if [ "$test" == "" ]; then
    hcloud context delete plexguide
    exit
  fi

fi

# Start Process
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG - Hetzner's Cloud Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://hcloud.pgblitz.com

[1] Deploy a New Server
[2] Destory a Server
A - List Server Info
B - Display Inital Server Passwords
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

if [ "$typed" == "1" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Create a Server Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p 'Type a Server Name | Press [ENTER]: ' name </dev/tty
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Hetzner's Cloud OS Selector
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Ubuntu 18.04 (PGBlitz Works)
[2] Ubuntu 16.04 (PGBlitz Works)
[3] Debian 9
[4] Centos 7
[5] Fendora 28
[6] Fendora 27
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

  if [ "$typed" == "1" ]; then
    os="ubuntu-18.04"
  elif [ "$typed" == "2" ]; then
    os="ubuntu-16.04"
  elif [ "$typed" == "3" ]; then
    os="debian-9"
  elif [ "$typed" == "4" ]; then
    os="centos-7"
  elif [ "$typed" == "5" ]; then
    os="fendora-28"
  elif [ "$typed" == "6" ]; then
    os="fendora-27"
  elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
    exit
  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Deploying Your Server!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  hcloud server create --name $name --type cx11 --image ubuntu-18.04 >/opt/appdata/plexguide/server.info

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - New Server Information - [$name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /opt/appdata/plexguide/server.info

  # Creates Log
  touch /opt/appdata/plexguide/server.store
  cat /opt/appdata/plexguide/server.info >>/opt/appdata/plexguide/server.store
  echo "Server Name: $name" >>/opt/appdata/plexguide/server.store
  echo "" >>/opt/appdata/plexguide/server.store

  # Variable Info
  serverip=$(cat /opt/appdata/plexguide/server.info | tail -n +3 | head -n 1 | cut -d " " -f2-)
  initialpw=$(cat /opt/appdata/plexguide/server.info | tail -n +4 | cut -d " " -f3-)

  tee <<-EOF

⚠️  To Reach Your Server >>> EXIT PG >>> TYPE: pg-$name ⚠️

✅️ [IMPORTANT NOTE]

Wait for one minute for the server to boot! Typing pg-$name will
display your initial password! Also can manually by typing:

Command: ssh root@$serverip
FIRST TIME LOGIN - Initial Password: $initialpw

EOF
  read -p 'Press [ENTER] to Exit ' fill </dev/tty

  # Creates Command pg-whatevername 2
  echo "" >>/bin/pg-$name
  echo "echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >/bin/pg-$name
  echo "echo '↘️  Server - $name | Initial Password $initialpw'" >>/bin/pg-$name
  echo "echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >>/bin/pg-$name
  echo "echo '✅️ Donate @ donate.pgblitz.com - Helps Costs & Mrs. Admin - #1 Enemy!'" >>/bin/pg-$name
  echo "echo ''" >>/bin/pg-$name
  echo "ssh root@$serverip" >>/bin/pg-$name
  chmod 777 /bin/pg-$name
  chown 1000:1000 /bin/pg-$name

  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit

elif [ "$typed" == "A" ] || [ "$typed" == "a" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Hetzner Server Cloud List
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Server Name
━━━━━━━━━━━
EOF
  hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-
  echo
  read -p 'Press [ENTER] to Continue! ' typed </dev/tty

  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit

elif [ "$typed" == "2" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Destory a Hetzner Cloud Server!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Server Name
━━━━━━━━━━━
EOF
  hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-
  echo
  echo "[Z] Exit"
  read -p 'Type a Server to Destroy | Press [ENTER]: ' destroy </dev/tty
  if [[ "$destroy" == "exit" || "$destroy" == "Exit" || "$destroy" == "EXIT" || "$destroy" == "z" || "$destroy" == "Z" ]]; then
    bash /opt/plexguide/menu/hetzner/hetzner.sh
    exit
  else
    check=$(hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
    next=$(echo $check | grep -c "\<$destroy\>")
    if [ "$next" == "0" ]; then
      tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  PG - Server: $destroy - Does Not Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -p 'Press [ENTER] to Continue! ' typed </dev/tty
      bash /opt/plexguide/menu/hetzner/hetzner.sh
      exit
    fi
    echo
    hcloud server delete $destroy
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Server: $destroy - Destroyed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Press [ENTER] to Continue! ' typed </dev/tty
    rm -rf /bin/pg-$destroy
    bash /opt/plexguide/menu/hetzner/hetzner.sh
    exit
  fi

elif [ "$typed" == "B" ] || [ "$typed" == "b" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Inital Server Passwords
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Useful if NEVER logged in! List created by this Server (new > old)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  touch /opt/appdata/plexguide/server.store
  tac -r /opt/appdata/plexguide/server.store
  echo "" &
  echo ""
  read -p 'Press [ENTER] to Continue! ' corn </dev/tty

  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit

elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
  exit
else
  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit
fi

#check=$(hcloud server list | grep "\<$sshin\>" | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
#ipcheck=$(echo $check | awk '{ print $3 }')
#⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
# read -n 1 -s -r -p "Press [ANY] Key to Continue "
