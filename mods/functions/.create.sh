#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################
// if DOESNT EXIST //

pgfunctions="/pg/mods/functions"

## temporary - delete later
mkdir -p $pgfunctions
touch $pgfunctions/ab $pgfunctions/cd $pgfunctions/ef

## reads functions and stores to a temporary file
ls /pg/mods/functions > /pg/mods/functions/.files.sh

## remove old master file if it exist
rm -rf "$pgfunctions/.master.sh" ## add the ignore thingy

cat <<- EOF > "$pgfunctions/.master.sh"
#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

EOF

## adds tempory information to complete master functions file
while read p; do
  echo "read $pgfunctions/$p" >> "$pgfunctions/.master.sh"
done </pg/mods/functions/.files.sh
