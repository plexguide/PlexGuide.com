#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

## if DOESNT EXIST ## avoid replicating # note

pgfunctions="/pg/mods/functions"
# mkdir -p "$pgfunctions"

## reads functions and stores to a temporary file
ls "$pgfunctions" > "$pgfunctions"/.files.sh

## remove old master file if it exist
rm -rf "$pgfunctions"/.master.sh ##

cat <<- EOF > "$pgfunctions/.master.sh"
#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

EOF

## adds tempory information to complete master functions file
while read p; do
  echo "source $pgfunctions/$p" >> "$pgfunctions"/.master.sh
done </"$pgfuncitons"/.files.sh
