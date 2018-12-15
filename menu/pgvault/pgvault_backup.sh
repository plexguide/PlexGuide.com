#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/pgvault.func

# FIRST QUESTION

question1 () {
### List Out Apps In Readable Order (One's Not Installed)
notrun=$(cat /var/plexguide/program.temp)
buildup=$(cat /var/plexguide/pgvault.output)

if [ "$buildup" == "" ]; then buildup="NONE"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Vault ~ Data Storage             📓 Reference: pgvault.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Potential Data to Backup

$notrun

💾 Apps Queued for Backup

$buildup

💬 Quitting? TYPE > exit | 💪 Ready to Backup? TYPE > deploy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 TYPE App Name for Backup Queue | Press [ENTER]: ' typed < /dev/tty
echo

if [ "$typed" == "deploy" ]; then backup_start; fi
if [ "$typed" == "exit" ]; then exit; fi

current2=$(cat /var/plexguide/pgvault.buildup | grep "\<$typed\>")
if [ "$current2" != "" ]; then queued && question1; fi

cat /var/plexguide/pgvault.buildup > /tmp/appcheck.5
cat /var/plexguide/pgvault.apprecall >> /tmp/appcheck.5
current1=$(cat /tmp/appcheck.5 | grep "\<$typed\>")
if [ "$current1" == "" ]; then badinput1 && question1; fi

buildup
}

# FUNCTIONS END ##############################################################
initial
apprecall
question1
