#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
echo "dummy" > /pg/var/final.choice

#### Note How to Make It Select a Type - echo "removal" > /pg/var/type.choice
program=$(cat /pg/var/type.choice)

menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /pg/var/final.choice)

### Loads Key Variables
bash /opt/plexguide/menu/interface/$program/var.sh
### Loads Key Execution
ansible-playbook /opt/plexguide/menu/core/selection.yml
### Executes Actions
bash /opt/plexguide/menu/interface/$program/file.sh

### Calls Variable Again - Incase of Break
menu=$(cat /pg/var/final.choice)

if [ "$menu" == "break" ];then
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: User Selected to Exit the Interface"
echo "---------------------------------------------------"
echo ""
sleep .5
fi

done
