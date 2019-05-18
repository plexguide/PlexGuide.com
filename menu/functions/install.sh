#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# This executes pgblitz for users upgrading from 8.6 and below
ansible-playbook /opt/plexguide/menu/alias/alias.yml
bash /opt/plexguide/functions/install.sh
