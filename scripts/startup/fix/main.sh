
## Upgrade away from Version 5 to 5.27
file="/var/plexguide/version.5"
if [ -e "$file" ]
then
   bash /opt/plexguide/scripts/startup/fix/001.sh
fi

## Fix if on 5.27 from Version 5.27 to 5.28
file="/var/plexguide/version-5.27"
if [ -e "$file" ]
then
   bash /opt/plexguide/scripts/startup/fix/002.sh
fi
