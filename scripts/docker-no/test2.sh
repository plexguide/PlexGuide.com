#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test2.sh

date1="Sat Dec 28 03:22:19 2013"
date2="Sun Dec 29 02:22:19 2013"
date -d @$(( $(date -d "$date2" +%s) - $(date -d "$date1" +%s) )) -u +'%H:%M:%S