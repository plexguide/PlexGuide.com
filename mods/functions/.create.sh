#!/bin/bash
############################################################## PlexGuide.com ###

## paths
pgprimary="/pg/mods/containers/primary"
pgcommunity="/pg/mods/containers/community"
fpath="/pg/mods/functions"

## remove old master file if it exist
rm -rf "$fpath"/.master.sh ##

## reads functions and stores to a temporary file
ls "$fpath" > "$fpath"/.functions.sh
ls "$pgprimary" > "$fpath"/.primary.sh
ls "$pgcommunity" > "$fpath"/.community.sh

## adds tempory information to complete master functions file
while read p; do
  echo "source $fpath/$p" >> "$fpath"/.master.sh
done </"$fpath"/.functions.sh

## adds tempory information to complete master functions file
echo "source $fpath/.master.sh" > "$fpath"/.primary_apps.sh

while read p; do
  echo "source $pgprimary/$p" >> "$fpath"/.master.sh
  echo "source $pgprimary/$p" >> "$fpath"/.primary_apps.sh
  echo "$p" >> "$fpath"/.primary_apps.sh
done </"$fpath"/.primary.sh
  bash "$fpath"/.primary_apps.sh

## adds tempory information to complete master functions file
while read p; do
  echo "source $pgcommunity/$p" >> "$fpath"/.master.sh
done </"$fpath"/.community.sh
