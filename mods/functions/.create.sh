#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###

# paths
pgprimary="/pg/mods/containers/primary"
pgcommunity="/pg/mods/containers/community"
pgpersonal="/pg/mods/containers/personal"
pgother="/pg/mods/containers/other"
fpath="/pg/mods/functions"

# remove old master file if it exist
rm -rf "$fpath"/.master.sh ##

# reads functions and stores to a temporary file
ls "$fpath" > "$fpath"/.functions.sh
ls "$pgprimary" > "$fpath"/.primary.sh
ls "$pgcommunity" > "$fpath"/.community.sh
ls "$pgpersonal" > "$fpath"/.personal.sh
ls "$pgother" > "$fpath"/.other.sh 

# adds tempory information to complete master functions file
while read p; do
  echo "source $fpath/$p" >> "$fpath"/.master.sh
done </"$fpath"/.functions.sh

# adds tempory information to complete master functions file
echo "source $fpath/.master.sh" > "$fpath"/.primary_apps.sh
echo "source $fpath/.master.sh" > "$fpath"/.community_apps.sh
echo "source $fpath/.master.sh" > "$fpath"/.personal_apps.sh
echo "source $fpath/.master.sh" > "$fpath"/.other_apps.sh

# builds apps for primary apps
while read p; do
  echo "source $pgprimary/$p" >> "$fpath"/.master.sh
  echo "source $pgprimary/$p" >> "$fpath"/.primary_apps.sh
  echo "$p" >> "$fpath"/.primary_apps.sh
done </"$fpath"/.primary.sh
  bash "$fpath"/.primary_apps.sh

# builds apps for community apps
while read p; do
  echo "source $pgcommunity/$p" >> "$fpath"/.master.sh
  echo "source $pgcommunity/$p" >> "$fpath"/.community_apps.sh
  echo "$p" >> "$fpath"/.community_apps.sh
done </"$fpath"/.community.sh
  bash "$fpath"/.community_apps.sh

# builds apps for personal apps
while read p; do
  echo "source $pgpersonal/$p" >> "$fpath"/.master.sh
  echo "source $pgpersonal/$p" >> "$fpath"/.personal_apps.sh
  echo "$p" >> "$fpath"/.personal_apps.sh
done </"$fpath"/.personal.sh
  bash "$fpath"/.personal_apps.sh

# other apps not accessiable to the users
while read p; do
  echo "source $pgother/$p" >> "$fpath"/.master.sh
  echo "source $pgother/$p" >> "$fpath"/.other_apps.sh
  echo "$p" >> "$fpath"/.other_apps.sh
done </"$fpath"/.other.sh
  bash "$fpath"/.other_apps.sh
