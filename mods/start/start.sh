#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
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
