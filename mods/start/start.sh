#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###
source /pg/mods/functions/.master.sh

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

# What Loads the Order of Execution
primestart(){
  start_basics
  start_menu
}

primestart
