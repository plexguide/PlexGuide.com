#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###

# paths
pgprimary="/pg/var/"
fpath="/pg/functions"

# remove old master file if it exist
rm -rf "$fpath"/.master.sh ##

# reads functions and stores to a temporary file
ls "$fpath" > "$fpath"/.functions.sh

# adds tempory information to complete master functions file
while read p; do
  echo "source $fpath/$p" >> "$fpath"/.master.sh
done </"$fpath"/.functions.sh
