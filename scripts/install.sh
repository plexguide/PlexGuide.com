#!/bin/bash

cd /opt/plexguide/scripts/tasks/
mv plexguide /bin
mv pgupdate /bin
cd /bin
chmod 755 /bin/plexguide
chmod 775 /bin/pgupdate
cd /opt/plexguide
