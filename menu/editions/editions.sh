#!/usr/bin/env python3
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
touch /var/plexguide/pg.edition
echeck=$(cat /var/plexguide/pg.edition)

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG Edition Selector
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  WARNING: You Can Only Select this Once!

1 - Edition: GDrive
2 - Edition: Solo  HD
3 - Edition: Multi HD
4 - Edition: GCE Feeder

★ Reference: http://editions.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
elif [ "$typed" == "4" ]; then
    echo "PG Edition - GCE Feed" > /var/plexguide/pg.edition
    echo "feeder" > /var/plexguide/pg.server.deploy
    cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Invalid Selection! Please Select an Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  bash /opt/plexguide/menu/editions/editions.sh
  exit
fi
