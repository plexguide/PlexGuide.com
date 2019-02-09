#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
file="/var/plexguide/pg.number"
if [ -e "$file" ]; then
  check="$(cat /var/plexguide/pg.number | head -c 1)"
  if [[ "$check" == "5" || "$check" == "6" || "$check" == "7" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLER BLOCK: Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We detected PG Version $check is running! Per the instructions, PG 8
must be installed on a FRESH BOX! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    exit; fi; fi

# Create Variables (If New) & Recall
pcloadletter () {
  touch /var/plexguide/pgclone.transport
  temp=$(cat /var/plexguide/pgclone.transport)
    if [ "$temp" == "umove" ]; then transport="PG Move /w No Encryption"
  elif [ "$temp" == "emove" ]; then transport="PG Move /w Encryption"
  elif [ "$temp" == "ublitz" ]; then transport="PG Blitz /w No Encryption"
  elif [ "$temp" == "eblitz" ]; then transport="PG Blitz /w Encryption"
  elif [ "$temp" == "solohd" ]; then transport="PG Local"
  else transport="NOT-SET"; fi
  echo "$transport" > /var/plexguide/pg.transport
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
  bash /opt/plexguide/menu/start/quotes.sh
  quote=$(cat /var/plexguide/startup.quote)
  source=$(cat /var/plexguide/startup.source)
}

# For New Installs, Forces This Menu To Display First; Vital For RClone
forcepgclone() {
quoteselect
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Interface Selection | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: New Install Interface! User Must Select a Mount Option First!

🌵 PG Disk Used Space:  $used of $capacity | $percentage Used Capacity

[1] PG Clone: Mount Transport
[Z] Exit

"$quote"

$source
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        bash /opt/plexguide/menu/pgcloner/pgclone.sh
        bash /opt/pgclone/gdrive.sh
        primestart ;;
    z )
        bash /opt/plexguide/menu/ending/ending.sh
        exit ;;
    Z )
        bash /opt/plexguide/menu/ending/ending.sh
        exit ;;
    * )
        forcepgclone ;;
esac

}

varstart() {
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  file="/var/plexguide"
  if [ ! -e "$file" ]; then
     mkdir -p /var/plexguide/logs 1>/dev/null 2>&1
     chown -R 0755 /var/plexguide 1>/dev/null 2>&1
     chmod -R 1000:1000 /var/plexguide 1>/dev/null 2>&1
  fi

  file="/opt/appdata/plexguide"
  if [ ! -e "$file" ]; then
     mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
     chown 0755 /opt/appdata/plexguide 1>/dev/null 2>&1
     chmod 1000:1000 /opt/appdata/plexguide 1>/dev/null 2>&1
  fi

  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  variable /var/plexguide/pgfork.project "NOT-SET"
  variable /var/plexguide/pgfork.version "NOT-SET"
  variable /var/plexguide/tld.program "NOT-SET"
  variable /opt/appdata/plexguide/plextoken "NOT-SET"
  variable /var/plexguide/server.ht ""
  variable /var/plexguide/server.ports ""
  variable /var/plexguide/server.incomplete.path ""
  variable /var/plexguide/server.email "NOT-SET"
  variable /var/plexguide/server.domain "NOT-SET"
  variable /var/plexguide/tld.type "standard"
  variable /var/plexguide/transcode.path "standard"
  variable /var/plexguide/pgclone.transport "NOT-SET"

  #### Temp Fix - Fixes Bugged AppGuard
  serverht=$(cat /var/plexguide/server.ht)
  if [ "$serverht" == "NOT-SET" ]; then
  rm /var/plexguide/server.ht
  touch /var/plexguide/server.ht
  fi

  hostname -I | awk '{print $1}' > /var/plexguide/server.ip
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END
  echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local

  # run pg main
  file="/var/plexguide/update.failed"
  if [ -e "$file" ]; then rm -rf /var/plexguide/update.failed
    exit; fi
  #################################################################################

  # Touch Variables Incase They Do Not Exist
  touch /var/plexguide/pg.edition
  touch /var/plexguide/server.id
  touch /var/plexguide/pg.number
  touch /var/plexguide/traefik.deployed
  touch /var/plexguide/server.ht
  touch /var/plexguide/server.ports
  touch /var/plexguide/pg.server.deploy

  # For PG UI - Force Variable to Set
  ports=$(cat /var/plexguide/server.ports)
  if [ "$ports" == "" ]; then echo "Open" > /var/plexguide/pg.ports
  else echo "Closed" > /var/plexguide/pg.ports; fi

  "ansible --version | head -n +1 | awk '{print $2'}" > /var/plexguide/pg.ansible
  "docker --version | head -n +1 | awk '{print $3'} | sed 's/,$//'" > /var/plexguide/pg.docker

  # Call Variables
  edition=$(cat /var/plexguide/pg.edition)
  serverid=$(cat /var/plexguide/server.id)
  pgnumber=$(cat /var/plexguide/pg.number)

  # Declare Traefik Deployed Docker STate
  docker ps --format '{{.Names}}' | grep traefik > /var/plexguide/traefik.deployed
  traefik=$(cat /var/plexguide/traefik.deployed)
  if [ "$traefik" == "" ]; then
    traefik="NOT DEPLOYED"
    echo "Not Deployed" > /var/plexguide/pg.traefik
  else
    traefik="DEPLOYED"
    echo "Deployed" > /var/plexguide/pg.traefik
  fi

  # For ZipLocations
  file="/var/plexguide/data.location"
  if [ ! -e "$file" ]; then echo "/opt/appdata/plexguide" > /var/plexguide/data.location; fi

  space=$(cat /var/plexguide/data.location)
  used=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $3}')
  capacity=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $2}')
  percentage=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $5}')
}

menuprime() {
  # New Setups Will Force To Use Mini Menu
  if [[ "$transport" == "NOT-SET" ]]; then
  forcepgclone
  exit; fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $transport | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 PG Disk Used Space: $used of $capacity | $percentage Used Capacity
EOF

  # Displays Second Drive If GCE
  edition=$(cat /var/plexguide/pg.server.deploy)
  if [ "$edition" == "feeder" ]; then
    used_gce=$(df -h /mnt | tail -n +2 | awk '{print $3}')
    capacity_gce=$(df -h /mnt | tail -n +2 | awk '{print $2}')
    percentage_gce=$(df -h /mnt | tail -n +2 | awk '{print $5}')
    echo "   GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
  fi

  disktwo=$(cat "/var/plexguide/server.hd.path")
  if [ "$edition" != "feeder" ]; then
    used_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $3}')
    capacity_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $2}')
    percentage_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $5}')

    if [[ "$disktwo" != "/mnt" ]]; then
    echo "   2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"; fi
  fi

quoteselect

tee <<-EOF

[1] Traefik : [$traefik]
[2] Defense : PG Shield /w Port Guard
[3] PG Clone: Mount Transport
[4] PG Box  : Apps ~ Core, Community & Removal
[5] PG Press: Deploy WordPress Instances
[6] PG Vault: Backup & Restore
[7] PG Cloud: GCE & Virtual Instances
[8] PG Tools
[9] PG Settings
[Z] Exit

"$quote"

$source
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  # Standby
read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
      bash /opt/plexguide/menu/pgcloner/traefik.sh
      bash /opt/traefik/traefik.sh
      primestart ;;
    2 )
      bash /opt/plexguide/menu/pgshield/pgshield.sh
      primestart ;;
    3 )
      bash /opt/plexguide/menu/pgcloner/pgclone.sh
      bash /opt/pgclone/gdrive.sh
      primestart ;;
    4 )
      bash /opt/plexguide/menu/pgbox/pgboxselect.sh
      primestart ;;
    5 )
      bash /opt/plexguide/menu/pgcloner/pgpress.sh
      bash /opt/pgpress/pressmain.sh
      primestart ;;
    6 )
      bash /opt/plexguide/menu/pgcloner/pgvault.sh
      bash /opt/pgvault/pgvault.sh
      primestart ;;
    7 )
      bash /opt/plexguide/menu/interface/cloudselect.sh
      primestart ;;
    8 )
      bash /opt/plexguide/menu/tools/tools.sh
      primestart ;;
    9 )
      bash /opt/plexguide/menu/settings/settings.sh
      primestart ;;
    z )
      bash /opt/plexguide/menu/ending/ending.sh
      exit ;;
    Z )
      bash /opt/plexguide/menu/ending/ending.sh
      exit ;;
    * )
      primestart ;;
esac
}

primestart
