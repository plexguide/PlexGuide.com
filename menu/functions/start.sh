#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh

sudocheck() {
if [[ $EUID -ne 0 ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
exit 1
fi
}

versioncheck() {
  rm -r /opt/pgstage
  mkdir -p /opt/pgstage
  ansible-playbook /opt/plexguide/menu/pgstage/pgstage.yml
  #git clone https://github.com/Admin9705/PlexGuide-Installer.git /opt/pgstage #&>/dev/null &
  #sudo wget --force-directories -O /opt/plexguide/menu/interface/version/version.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/menu/interface/version/version.sh &>/dev/null &
}

downloadpg() {
  rm -rf /opt/plexguide
  git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide && cp /opt/plexguide/menu/interface/alias/templates/plexguide /bin/
  cp /opt/plexguide/menu/interface/alias/templates/plexguide /bin/plexguide
}

missingpull() {
file="/opt/plexguide/menu/functions/install.sh"
if [ ! -e "$file" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  /opt/plexguide went missing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 2
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🍖  NOM NOM - Re-Downloading PlexGuide for BoneHead User!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
  versioncheck
  downloadpg
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  Repair Complete! Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 2
  fi
}

exitcheck() {
bash /opt/plexguide/menu/version/file.sh
file="/var/plexguide/exited.upgrade"
if [ ! -e "$file" ]; then
	bash /opt/plexguide/menu/ending/ending.sh
else
	rm -rf /var/plexguide/exited.upgrade 1>/dev/null 2>&1
	echo ""
	bash /opt/plexguide/menu/ending/ending.sh
fi
}
######################################################## START: Key Variables
bash /opt/plexguide/install/declare.sh
######################################################## START: New Install
bash /opt/plexguide/install/reboot.sh
