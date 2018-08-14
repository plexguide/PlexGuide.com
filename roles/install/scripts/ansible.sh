#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
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

######################################################## Declare Variables
sname="Ansible - Install"
pg_ansible=$( cat /var/plexguide/pg.ansible )
pg_ansible_stored=$( cat /var/plexguide/pg.ansible.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_ansible" == "$pg_ansible_stored" ]; then
      echo "" 1>/dev/null 2>&1
    else
      dialog --infobox "Installing | Upgrading Ansible" 3 40
      sleep 2
      clear
      sudo apt-get remove ansible -y
      sudo apt-add-repository --remove ppa:ansible/ansible -y && sudo add-apt-repository ppa:ansible/ansible-2.5 -y && sudo apt install ansible -y
      apt-get update -y
      apt-get install ansible 2.5.5 -y
      apt-mark hold ansible
      yes | apt-get update

      ############# FOR ANSIBLE
      mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
      echo "[local]" > /etc/ansible/inventories/local
      echo "127.0.0.1 ansible_connection=local" >> /etc/ansible/inventories/local

      ### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
      echo "[defaults]" > /etc/ansible/ansible.cfg
      echo "command_warnings = False" >> /etc/ansible/ansible.cfg
      echo "callback_whitelist = profile_tasks" >> /etc/ansible/ansible.cfg
      echo "inventory = /etc/ansible/inventories/local" >> /etc/ansible/ansible.cfg

      cat /var/plexguide/pg.ansible > /var/plexguide/pg.ansible.stored
  fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
