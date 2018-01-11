#!/bin/bash

cp -rf '/opt/appdata/plex/database/Library/Application Support' /mnt/gdrivef/plex/

mv '/opt/appdata/plex/database/Library/Application Support' '/opt/appdata/plex/database/Library/Application Support.OLD'

ln -s '/mnt/storagespace/.plex/Application Support' '/opt/appdata/plex/database/Library/Application Support'

chown -R plex.plex '/opt/appdata/plex/database/Library/Application Support'
