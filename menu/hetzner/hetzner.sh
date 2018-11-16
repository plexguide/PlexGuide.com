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
#################################################################################
file="~/.ssh/id_rsa"
if [ ! -e "$file" ]; then
  serverstatus="Generated"
else
  serverstatus="Not Generated"
fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Hetzner's Cloud Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Generate Keys        [$serverstatus]
2 - Deploy a New Server  [deploy]
3 - List Server Info
4 - Destory a Server
5 - Login to a Server
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
ssh-keygen -t rsa -b 4096 -C "pg@plexguide.com" -f ~/.ssh/id_rsa.pub
bash /opt/plexguide/menu/hetzner/hetzner.sh
exit
elif [ "$typed" == "2" ]; then

echo
read -p 'Type a Server Name | Press [ENTER]: ' name < /dev/tty
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Hetzner's Cloud OS Selector
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Ubuntu 18.04 (PlexGuide Works)
2 - Ubuntu 16.04 (PlexGuide Works)
3 - Debian 9
4 - Centos 7
5 - Fendora 28
6 - Fendora 27
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then os="ubuntu-18.04";
elif [ "$typed" == "2" ]; then os="ubuntu-16.04";
elif [ "$typed" == "3" ]; then os="debian-9";
elif [ "$typed" == "4" ]; then os="centos-7";
elif [ "$typed" == "5" ]; then os="fendora-28";
elif [ "$typed" == "6" ]; then os="fendora-27";
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then exit;
  fi

  if [ "$serverstatus" != "Generated" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Generating a Public Key for Hetzner
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  hcloud ssh-key create --name plexguide --public-key-from-file ~/.ssh/id_rsa.pub
  fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Deploying Your Server!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  hcloud server create --name $name --type cx11 --image ubuntu-18.04 --ssh-key plexguide
echo
echo "🚀 To SSH into Your Server, use PG or type ssh root@ipv4.address"
echo "   Wait 30 seconds before attempting to login to the server"
echo
read -p 'Press [ENTER] to Exit ' fill < /dev/tty

bash /opt/plexguide/menu/hetzner/hetzner.sh
exit

elif [ "$typed" == "3" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Hetzner Server Cloud List
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Server Name
━━━━━━━━━━━
EOF
hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-
echo
read -p 'Press [ENTER] to Continue! ' typed < /dev/tty

bash /opt/plexguide/menu/hetzner/hetzner.sh
exit

elif [ "$typed" == "4" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Destory a Hetzner Cloud Server!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Server Name
━━━━━━━━━━━
EOF
hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-
echo
echo "Quit? Type >>> exit"
read -p 'Type a Server to Destroy | Press [ENTER]: ' destroy < /dev/tty
  if [ "$destroy" == "exit" ]; then
    bash /opt/plexguide/menu/hetzner/hetzner.sh
    exit
  else
    check=$(hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
    next=$(echo $check | grep -c "\<$destroy\>")
    if [ "$next" == "0" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Server: $destroy - Does Not Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Press [ENTER] to Continue! ' typed < /dev/tty
    bash /opt/plexguide/menu/hetzner/hetzner.sh
    exit
  fi
  echo
  hcloud server delete $destroy
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Server: $destroy - Destroyed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Press [ENTER] to Continue! ' typed < /dev/tty
    bash /opt/plexguide/menu/hetzner/hetzner.sh
    exit
fi
elif [ "$typed" == "5" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Active Running Hetzner Servers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Server Name
━━━━━━━━━━━
EOF
  hcloud server list | tail -n +2 | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-
  echo
  read -p 'Press [ENTER] to Continue! ' typed < /dev/tty

  echo
  echo "Quit? Type >>> exit"
  read -p 'Type a Server Name to Login To | Press [ENTER]: ' sshin < /dev/tty
    if [ "$sshin" == "exit" ]; then
      bash /opt/plexguide/menu/hetzner/hetzner.sh
      exit
    else
      check=$(hcloud server list | grep "\<$sshin\>" | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
      ipcheck=$(echo $check | awk '{ print $3 }')
      if [ "$ipcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Server: $sshin - Does Not Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -p 'Press [ENTER] to Continue! ' typed < /dev/tty
      bash /opt/plexguide/menu/hetzner/hetzner.sh
      exit
    fi
    echo
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Server: $sshin - Attempting to Login
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      #ssh-keygen -f "/root/.ssh/known_hosts" -R $ipcheck
      ssh root@$ipcheck
      bash /opt/plexguide/menu/hetzner/hetzner.sh
      exit
  fi

  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
  exit
else
  bash /opt/plexguide/menu/hetzner/hetzner.sh
  exit
fi

#⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
# read -n 1 -s -r -p "Press [ANY] Key to Continue "
