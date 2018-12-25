#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
bash /opt/plexguide/menu/editions/gcechecker.sh
file1="/var/plexguide/gce.false"
if [ ! -e "$file1" ]; then exit; fi

# Forces Exit if GCE
touch /var/plexguide/pg.server.deploy
fcheck=$(cat /var/plexguide/pg.server.deploy)
if [ "$fcheck" == "feeder" ]; then exit; fi

# Starting Process If Not GCE
if [[ "$fcheck" == "PG Edition - GDrive" || "$fcheck" == "PG Edition - HD Solo" || "$fcheck" == "PG Edition - HD Multi" ]]; then
exit; fi 

touch /var/plexguide/pg.edition
echeck=$(cat /var/plexguide/pg.edition)

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG Edition Selector
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡  Reference: http://editions.plexguide.com

1 - Edition: GDrive
2 - Edition: Solo  HD
3 - Edition: Multi HD

⚠️  NOTE: Can Only Select this Once!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    echo "PG Edition - GDrive" > /var/plexguide/pg.edition
    echo "gdrive" > /var/plexguide/pg.server.deploy
    cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
elif [ "$typed" == "2" ]; then
    echo "PG Edition - HD Solo" > /var/plexguide/pg.edition
    echo "drive" > /var/plexguide/pg.server.deploy
    cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
elif [ "$typed" == "3" ]; then
    echo "PG Edition - HD Multi" > /var/plexguide/pg.edition
    echo "drives" > /var/plexguide/pg.server.deploy
    cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Invalid Selection! Please Select an Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  bash /opt/plexguide/menu/editions/editions.sh
  exit
fi
