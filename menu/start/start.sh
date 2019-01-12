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
variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
file="/var/plexguide"
if [ ! -e "$file" ]; then
   mkdir -p /var/plexguide 1>/dev/null 2>&1
   chown 0755 /var/plexguide 1>/dev/null 2>&1
   chmod 1000:1000 /var/plexguide 1>/dev/null 2>&1
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
variable /var/plexguide/server.incomplete.path ""
variable /var/plexguide/server.email "NOT-SET"
variable /var/plexguide/server.domain "NOT-SET"

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

## Selects an edition
touch /var/plexguide/pg.edition
edition=$( cat /var/plexguide/pg.edition )
if [ "$edition" == "PG Edition - GDrive" ]; then a=b
elif [ "$edition" == "PG Edition - HD Multi" ]; then a=b
elif [ "$edition" == "PG Edition - HD Solo" ]; then a=b
elif [ "$edition" == "PG Edition - GCE Feed" ]; then a=b
else
    file="/var/plexguide/pg.preinstall.stored"
    if [ -e "$file" ]; then
      touch /var/plexguide/pg.edition
      bash /opt/plexguide/menu/interface/install/scripts/edition.sh
      #bash-/opt/plexguide/pg.sh
    fi
fi

#################################################################################

# Touch Variables Incase They Do Not Exist
touch /var/plexguide/pg.edition
touch /var/plexguide/server.id
touch /var/plexguide/pg.number
touch /var/plexguide/traefik.deployed
touch /var/plexguide/server.ht
touch /var/plexguide/server.ports

# Call Variables
edition=$(cat /var/plexguide/pg.edition)
serverid=$(cat /var/plexguide/server.id)
pgnumber=$(cat /var/plexguide/pg.number)

# Declare Traefik Deployed Docker STate
docker ps --format '{{.Names}}' | grep traefik > /var/plexguide/traefik.deployed
traefik=$(cat /var/plexguide/traefik.deployed)
if [ "$traefik" == "" ]; then
  traefik="NOT DEPLOYED"
else
  traefik="DEPLOYED"
fi

# For ZipLocations
file="/var/plexguide/data.location"
if [ ! -e "$file" ]; then echo "/opt/appdata/plexguide" > /var/plexguide/data.location; fi

space=$(cat /var/plexguide/data.location)
used=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $3}')
capacity=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $2}')
percentage=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $5}')

edition=$( cat /var/plexguide/pg.edition )
if [ "$edition" == "PG Edition - GDrive" ]; then a=b
elif [ "$edition" == "PG Edition - GDrive" ]; then a=b
elif [ "$edition" == "PG Edition - HD Multi" ]; then a=b
elif [ "$edition" == "PG Edition - HD Solo" ]; then a=b; fi
# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $edition | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 PG Disk Used Space:  $used of $capacity | $percentage Used Capacity
EOF

# Displays Second Drive If GCE
if [ "$edition" == "PG Edition - GCE Feed" ]; then
  used_gce=$(df -h /mnt | tail -n +2 | awk '{print $3}')
  capacity_gce=$(df -h /mnt | tail -n +2 | awk '{print $2}')
  percentage_gce=$(df -h /mnt | tail -n +2 | awk '{print $5}')
  echo "   GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
fi

disktwo=$(cat "/var/plexguide/server.hd.path")
if [ "$edition" != "PG Edition - GCE Feed" ]; then
  used_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $3}')
  capacity_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $2}')
  percentage_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $5}')

  if [[ "$disktwo" != "/mnt" ]]; then
  echo "   2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"; fi

fi

bash /opt/plexguide/menu/start/quotes.sh

quote=$(cat /var/plexguide/startup.quote)
source=$(cat /var/plexguide/startup.source)
echo
echo "[1] Traefik : [$traefik]"
echo "[2] Defense : PG Shield /w Port Guard"

if [ "$edition" == "PG Edition - GDrive" ]; then echo "[3] PG Clone: Mount Transport"
elif [ "$edition" == "PG Edition - GCE Feed" ]; then echo "[3] PG Clone: Mount Transport"
elif [ "$edition" == "PG Edition - HD Multi" ]; then echo "[3] MultiHD : MultiFS Combined Mounts"
elif [ "$edition" == "PG Edition - HD Solo" ]; then echo "[3] No Mounts for Solo HD"
else
  echo "[2] Mounts & Data Transports"
  echo "PG Edition - GDrive" > /var/plexguide/pg.edition
fi

tee <<-EOF
[4] Box Apps: Core
[5] Box Apps: Community
[6] Box Apps: Removal
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

  if [ "$typed" == "3" ]; then

    if [ "$edition" == "PG Edition - GDrive" ]; then bash /opt/plexguide/menu/pgclone/gdrive.sh
    elif [ "$edition" == "PG Edition - GCE Feed" ]; then bash /opt/plexguide/menu/pgclone/gdrive.sh
    elif [ "$edition" == "PG Edition - HD Multi" ]; then bash /opt/plexguide/menu/multihd/scripts/main.sh
    elif [ "$edition" == "PG Edition - HD Solo" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Using Solo HD Edition! You Cannot Set Mounts! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
  else
  bash /opt/plexguide/menu/transport/transport.sh
     fi

elif [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/traefik/traefik.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/pgshield/pgshield.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/pgbox/pgboxcore.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/pgbox/pgboxcommunity.sh
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/removal/removal.sh
elif [ "$typed" == "7" ]; then
  bash /opt/plexguide/menu/cloudselect/cloudselect.sh
elif [ "$typed" == "8" ]; then
  bash /opt/plexguide/menu/tools/tools.sh
elif [ "$typed" == "9" ]; then
  bash /opt/plexguide/menu/settings/settings.sh
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
  bash /opt/plexguide/menu/ending/ending.sh
  exit
else
  bash /opt/plexguide/menu/start/start.sh
  exit
fi

bash /opt/plexguide/menu/start/start.sh
exit
