#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide/pg.docker.stored
start=$( cat /var/plexguide/pg.docker )
stored=$( cat /var/plexguide/pg.docker.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: PG Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Docker runs Apps that are utilized by PlexGuide

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
sleep 5

# Execute Ansible Function
ansible-playbook /opt/plexguide/pg.yml --tags docker

# If Docker FAILED, Emergency Install
file="/usr/bin/docker" 1>/dev/null 2>&1
if [ ! -e "$file" ]; then
    clear
    echo "Installing Docker the Old School Way - (Please Be Patient)"
    sleep 2
    clear
    curl -fsSL get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo ""
    echo "Starting Docker (Please Be Patient)"
    sleep 2
    systemctl start docker
    sleep 2
fi

##### Checking Again, if fails again; warns user
file="/usr/bin/docker" 1>/dev/null 2>&1
if [ -e "$file" ]
  then
  echo "INFO - SUCCESS: Docker Installed!"
  sleep 5
else
  echo "INFO - FAILED: Docker Failed to Install! Exiting PlexGuide!"
    exit
  fi

# Prevents From Repeating
cat /var/plexguide/pg.docker > /var/plexguide/pg.docker.stored

fi
