#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
file="/pg/var/pg.number"
if [ -e "$file" ]; then
  check="$(cat /pg/var/pg.number | head -c 1)"
  if [[ "$check" == "5" || "$check" == "6" || "$check" == "7" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLER BLOCK: Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We detected PG Version $check is running! Per the instructions, PG 8
must be installed on a FRESH BOX! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    exit; fi; fi

# Create Variables (If New) & Recall
pcloadletter () {
  touch /pg/var/pgclone.transport
  temp=$(cat /pg/var/pgclone.transport)
    if [ "$temp" == "umove" ]; then transport="PG Move /w No Encryption"
  elif [ "$temp" == "emove" ]; then transport="PG Move /w Encryption"
  elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"
  elif [ "$temp" == "eblitz" ]; then transport="PG Blitz /w Encryption"
  elif [ "$temp" == "solohd" ]; then transport="PG Local"
  else transport="NOT-SET"; fi
  echo "$transport" > /pg/var/pg.transport
}

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

# What Loads the Order of Execution
primestart(){
  pcloadletter
  varstart
  menuprime
}

# When Called, A Quoate is Randomly Selected
quoteselect () {
  bash /pg/pgblitz/menu/start/quotes.sh
  quote=$(cat /pg/var/startup.quote)
  source=$(cat /pg/var/startup.source)
}

varstart() {
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  file="/pg/var"
  if [ ! -e "$file" ]; then
     mkdir -p /pg/var/logs 1>/dev/null 2>&1
     chown -R 0775 /pg/var 1>/dev/null 2>&1
     chmod -R 1000:1000 /pg/var 1>/dev/null 2>&1
  fi

  file="/pg/data/blitz"
  if [ ! -e "$file" ]; then
     mkdir -p /pg/data/blitz 1>/dev/null 2>&1
     chown 0775 /pg/data/blitz 1>/dev/null 2>&1
     chmod 1000:1000 /pg/data/blitz 1>/dev/null 2>&1
  fi

  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  variable /pg/var/pgfork.project "NOT-SET"
  variable /pg/var/pgfork.version "NOT-SET"
  variable /pg/var/tld.program "NOT-SET"
  variable /pg/var/plextoken "NOT-SET"
  variable /pg/var/server.ht ""
  variable /pg/var/server.ports "127.0.0.1:"
  variable /pg/var/server.email "NOT-SET"
  variable /pg/var/server.domain "NOT-SET"
  variable /pg/var/tld.type "standard"
  variable /pg/var/transcode.path "standard"
  variable /pg/var/pgclone.transport "NOT-SET"
  variable /pg/var/plex.claim ""

  #### Temp Fix - Fixes Bugged AppGuard
  serverht=$(cat /pg/var/server.ht)
  if [ "$serverht" == "NOT-SET" ]; then
  rm /pg/var/server.ht
  touch /pg/var/server.ht
  fi

  hostname -I | awk '{print $1}' > /pg/var/server.ip
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END
  echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local

  # run pg main
  file="/pg/var/update.failed"
  if [ -e "$file" ]; then rm -rf /pg/var/update.failed
    exit; fi
  #################################################################################

  # Touch Variables Incase They Do Not Exist
  touch /pg/var/pg.edition
  touch /pg/var/server.id
  touch /pg/var/pg.number
  touch /pg/var/traefik.deployed
  touch /pg/var/server.ht
  touch /pg/var/server.ports
  touch /pg/var/pg.server.deploy

  # For PG UI - Force Variable to Set
  ports=$(cat /pg/var/server.ports)
  if [ "$ports" == "" ]; then echo "Open" > /pg/var/pg.ports
  else echo "Closed" > /pg/var/pg.ports; fi

  ansible --version | head -n +1 | awk '{print $2'} > /pg/var/pg.ansible
  docker --version | head -n +1 | awk '{print $3'} | sed 's/,$//' > /pg/var/pg.docker
  cat /etc/os-release | head -n +5 | tail -n +5 | cut -d'"' -f2 > /pg/var/pg.os

  file="/pg/var/gce.false"
  if [ -e "$file" ]; then echo "No" > /pg/var/pg.gce; else echo "Yes" > /pg/var/pg.gce; fi

  # Call Variables
  edition=$(cat /pg/var/pg.edition)
  serverid=$(cat /pg/var/server.id)
  pgnumber=$(cat /pg/var/pg.number)

  # Declare Traefik Deployed Docker State
  if [[ $(docker ps | grep "traefik") == "" ]]; then
    traefik="NOT DEPLOYED"
    echo "Not Deployed" > /pg/var/pg.traefik
  else
    traefik="DEPLOYED"
    echo "Deployed" > /pg/var/pg.traefik
  fi

  if [[ $(docker ps | grep "oauth") == "" ]]; then
    traefik="NOT DEPLOYED"
    echo "Not Deployed" > /pg/var/pg.auth
  else
    traefik="DEPLOYED"
    echo "Deployed" > /pg/var/pg.oauth
  fi

  # For ZipLocations
  file="/pg/var/data.location"
  if [ ! -e "$file" ]; then echo "/pg/data/blitz" > /pg/var/data.location; fi

  space=$(cat /pg/var/data.location)
  used=$(df -h /pg/data/blitz | tail -n +2 | awk '{print $3}')
  capacity=$(df -h /pg/data/blitz | tail -n +2 | awk '{print $2}')
  percentage=$(df -h /pg/data/blitz | tail -n +2 | awk '{print $5}')

  # For the PGBlitz UI
  echo "$used" > /pg/var/pg.used
  echo "$capacity" > /pg/var/pg.capacity
}

menuprime() {
# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $transport | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 PG Disk Used Space: $used of $capacity | $percentage Used Capacity
EOF

  # Displays Second Drive If GCE
  edition=$(cat /pg/var/pg.server.deploy)
  if [ "$edition" == "feeder" ]; then
    used_gce=$(df -h /mnt | tail -n +2 | awk '{print $3}')
    capacity_gce=$(df -h /mnt | tail -n +2 | awk '{print $2}')
    percentage_gce=$(df -h /mnt | tail -n +2 | awk '{print $5}')
    echo "   GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
  fi

  disktwo=$(cat "/pg/var/hd.path")
  if [ "$edition" != "feeder" ]; then
    used_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $3}')
    capacity_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $2}')
    percentage_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $5}')

    if [[ "$disktwo" != "/pg" ]]; then
    echo "   2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"; fi
  fi

  # Declare Ports State
  ports=$(cat /pg/var/server.ports)

  if [ "$ports" == "" ]; then ports="OPEN"
  else ports="CLOSED"; fi

quoteselect

tee <<-EOF

[1]  Traefik   : Reverse Proxy   |  [6]  Press: Word Press Deployment
[2]  Port Guard: [$ports] Ports  |  [7]  Vault: Backup & Restore
[3]  Shield : Google Protection  |  [8]  Cloud: Deploy GCE & Hetzner
[4]  Clone  : Mount Transport    |  [9]  Tools: Misc Products
[5]  Box    : Apps ~ Programs    |  [10] Settings
[Z]  Exit

"$quote"

$source
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  # Standby
read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
      bash /pg/stage/pgcloner/traefik.sh
      primestart ;;
    2 )
      bash /pg/pgblitz/menu/portguard/portguard.sh
      primestart ;;
    3 )
      bash /pg/stage/pgcloner/pgshield.sh
      primestart ;;
    4 )
      bash /pg/stage/pgcloner/pgclone.sh
      primestart ;;
    5 )
      bash /pg/stage/pgcloner/apps.sh
      primestart ;;
    6 )
      bash /pg/stage/pgcloner/pgpress.sh
      primestart ;;
    7 )
      bash /pg/stage/pgcloner/pgvault.sh
      primestart ;;
    8 )
      bash /pg/pgblitz/menu/interface/cloudselect.sh
      primestart ;;
    9 )
      bash /pg/pgblitz/menu/tools/tools.sh
      primestart ;;
    10 )
      bash /pg/pgblitz/menu/interface/settings.sh
      primestart ;;
    z )
      bash /pg/pgblitz/menu/interface/ending.sh
      exit ;;
    Z )
      bash /pg/pgblitz/menu/interface/ending.sh
      exit ;;
    * )
      primestart ;;
esac
}

primestart
