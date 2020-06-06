#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /pg/pgblitz/menu/functions/functions.sh
# Menu Interface
question1 (){
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG System & Network Auditor
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] System & Network Benchmark - Basic
[2] System & Network Benchmark - Advanced
[3] Simple SpeedTest
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [Enter]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  sudo wget -qO- bench.sh | bash
  echo ""
  read -p '🌍 Process Complete | Press [Enter] ' typed < /dev/tty
  question1
elif [ "$typed" == "2" ]; then
  echo ""
  curl -LsO raw.githubusercontent.com/PGBlitz/Bench/master/bench.sh; chmod +x bench.sh; chmod +x bench.sh
  echo ""
  ./bench.sh -a
  echo ""
  read -p '🌍 Process Complete | Press [Enter] ' typed < /dev/tty
  question1
elif [ "$typed" == "3" ]; then
  pip install speedtest-cli
  echo ""
  speedtest-cli
  echo ""
  read -p '🌍 Process Complete | Press [Enter] ' typed < /dev/tty
  question1
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
  exit
else
  badinput1
fi
}

question1
