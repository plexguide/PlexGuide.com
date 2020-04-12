#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

## remove old master file if it exist
rm -rf "$pgfunctions"/.master.sh ##

## paths
pgfunctions="/pg/mods/functions"
pgprimary="/pg/mods/containers/primary"
pgcommunity="/pg/mods/containers/community"

## reads functions and stores to a temporary file
ls "$pgfunctions" > "$pgfunctions"/.functions.sh
ls "$pgprimary" > "$pgfunctions"/.primary.sh
ls "$pgcommunity" > "$pgfunctions"/.community.sh

## adds tempory information to complete master functions file
while read p; do
  echo "source $pgfunctions/$p" >> "$pgfunctions"/.master.sh
done </"$pgfunctions"/.functions.sh

## adds tempory information to complete master functions file
echo ""$pgfunctions"/.master.sh" > "$pgfunctions"/.primary_apps.sh

while read p; do
  echo "source $pgprimary/$p" >> "$pgfunctions"/.master.sh
  echo "source $pgprimary/$p" >> "$pgfunctions"/.primary_apps.sh
  echo "$p" >> "$pgfunctions"/.primary_apps.sh 
done </"$pgfunctions"/.primary.sh
  bash "$pgfunctions"/.primary_apps.sh

## adds tempory information to complete master functions file
while read p; do
  echo "source $pgcommunity/$p" >> "$pgfunctions"/.master.sh
done </"$pgfunctions"/.community.sh
