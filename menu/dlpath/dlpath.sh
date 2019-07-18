#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# Create Variables (If New) & Recall
variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" >$1; fi
}

# For ZipLocations

variable /var/plexguide/server.hd.path "/mnt"
pgpath=$(cat /var/plexguide/server.hd.path)

used=$(df -h $pgpath | tail -n +2 | awk '{print $3}')
capacity=$(df -h $pgpath | tail -n +2 | awk '{print $2}')
percentage=$(df -h $pgpath | tail -n +2 | awk '{print $5}')
###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Processing Disk Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵  Processing Disk : $pgpath
    Processing Space: $used of $capacity | $percentage Used Capacity

☑️   PG does not format your second disk, nor mount it! We can
only assist by changing the location path!

☑️   Enables PG System to process items on a SECONDARY Drive rather
than tax the PRIMARY DRIVE. Like Windows, you can have your items
process on a (D): Drive instead of on a (C): Drive.

Do You Want To Change the Processing Disk?

[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p '↘️   Type a Number | Press [ENTER]: ' typed </dev/tty

if [ "$typed" == "1" ]; then
  exit
elif [ "$typed" == "2" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM: Selected to Change the Processing Path
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵  Current Processing Disk : $pgpath

☑️   Type the path as show in the examples below! PG will then attempt
to see if your path exists!

Examples:
/mnt/mymedia
/secondhd/media
/myhd/storage/media

STOP the Process by Typing >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -p '↘️   Type the NEW PATH (Follow Above Examples): ' typed </dev/tty

  # SubQuestion About Continuing
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    exit
  fi

  # Checking Input
  typed2=$typed
  bonehead=no
  ##### If BONEHEAD forgot to add a / in the beginning, we fix for them
  initial="$(echo $typed | head -c 1)"
  if [ "$initial" != "/" ]; then
    typed="/$typed"
    bonehead=yes
  fi
  ##### If BONEHEAD added a / at the end, we fix for them
  initial="${typed: -1}"
  if [ "$initial" == "/" ]; then
    typed=${typed::-1}
    bonehead=yes
  fi

  # Telling Them They Are a BoneHead
  if [ "$bonehead" == "yes" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☠  BONEHEAD:  PG Fixed the Paths For You... (read next time)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You Typed : $typed2
Changed To: $typed
EOF
    sleep 5
  else
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ WOOT WOOT: The Input is Valid!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM: Checking the Processing Path's Existance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  sleep 3

  mkdir $typed/test 1>/dev/null 2>&1

  file="$typed/test"
  if [ -e "$file" ]; then

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️   WOOT WOOT: Location Is Valid - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  STANDBY: Setting Up Your Permissions
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2

    chown 1000:1000 "$typed"
    chmod 0775 "$typed"
    rm -rf "$typed/test"
    echo $typed >/var/plexguide/server.hd.path
    break=off

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  STANDBY: Making Folders & Rebuilding the Systems Docker Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2

    ansible-playbook /opt/plexguide/menu/installer/main.yml
    bash /opt/plexguide/menu/dlpath/rebuild.sh

    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️   WOOT WOOT: Process Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  else
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Mount Error!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$typed does not exist!

You may have forgotten to create it, but PG is unable to see it!
Try >>> cd $path and see what happens!

Exiting! Nothing has changed!

EOF
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  fi
else

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM: Failed to Make a Valid Selection! Restarting the Process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  bash /opt/plexguide/menu/dlpath/dlpath.sh
  exit
fi

exit
