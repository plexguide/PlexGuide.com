#!/bin/bash

### For NZBGET
echo "nzbget" > /tmp/program_var
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags autodelete

### For SABNZBD
# later