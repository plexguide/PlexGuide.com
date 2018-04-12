#!/bin/bash
# Title:    PlexGuide Auth Scan (Security Checkup)
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

# sanity check, then get ip
ping icanhazip.com -c 1 &>/dev/null || exit 1
if [[ ! -e /var/plexguide/basics.yes ]]; then
  exit 1; fi
ip=$(curl -s icanhazip.com)
which curl &>/dev/null || exit 1


sonarr () {
curl -m 5 -s $ip:8989 -o html \
  && grep -iq api html \
  && echo "Sonarr Has No Password On $ip:8989" >> /var/plexguide/nopassword
}

radarr () {
curl -m 5 -s $ip:7878 -o html \
  && grep -iq api html \
  && echo "Radarr Has No Password On $ip:7878" >> /var/plexguide/nopassword
}

lidarr () {
curl -m 5 -s $ip:8686 -o html \
  && grep -iq api html \
  && echo "Lidarr Has No Password On $ip:8686" >> /var/plexguide/nopassword
}

portainer () {
curl -m 5 -s $ip:9000/api/users/admin/check -o html \
  && grep -iq '{"err":"User not found"}' html \
  && echo "Portainer Has No Password On $ip:9000" >> /var/plexguide/nopassword
}

deluge () {
curl -d '{"method":"auth.login","params":["deluge"],"id":7}' \
  -H "Content-Type: application/json" \
   $ip:8112/json -m 5 -i -s -o html \
   && grep -iq 'Set-Cookie:' html \
   && echo "Deluge Has Default Password: \"deluge\" On $ip:8112" >> /var/plexguide/nopassword
}

rutorrent () {
curl -i -m 5 -s $ip:8999 -o html \
  && grep -iq '200 OK' html \
  && echo "ruTorrent Has No Password On $ip:8999" >> /var/plexguide/nopassword
}

resilio () {
curl -i -m 5 -s $ip:8888 -o html \
  && grep -iq '200 OK' html \
  && echo "resilio Has No Password On $ip:8888" >> /var/plexguide/nopassword
}

#jackett () {
#curl -i -m 5 -s $ip:9117 -o html
#  if [[ $(cat html | wc -l) -gt 100 ]]; then
#  echo "Jackett Has No Password On $ip:9117" >> /var/plexguide/nopassword
#  fi
# }

nzbget () {
curl -i -s -m 5 $ip:6789 -o html \
  && grep -q 'Auth-Type=http' html \
  && echo "NZBget Has No Password On $ip:6789"  >> /var/plexguide/nopassword
}

sabnzbd () {
curl -i -s -m 5 $ip:8080 -o html \
  && grep -q '200 OK' html \
  && echo "SABNZBD Has No Password On $ip:8080"  >> /var/plexguide/nopassword
}

nzbhydra () {
curl -i -s -m 5 $ip:5075 -o html \
  && grep -q '"authType": "none"' html \
  && echo "NZBHydra Has No Password On $ip:5075"  >> /var/plexguide/nopassword
}

nzbhydra2 () {
curl -i -s -m 5 $ip:5076 -o html \
  && grep -q '"authType":"NONE"' html \
  && echo "NZBHydra2 Has No Password On $ip:5076"  >> /var/plexguide/nopassword
}

emby () {
  curl -i -s -m 5 $ip:8096/emby/users/public -o html \
  && grep -q '"HasPassword":false' \
  && echo "An Emby User Has No Password On $ip:8096"
}

duplicati () {
curl -i -s -m 5 $ip:8200 -o html \
  && grep -q '200 OK' html \
  && echo "duplicati Has No Password On $ip:8200"  >> /var/plexguide/nopassword
}

#medusa () {
#curl -i -m 5 -s $ip:8081 -o html
#  if [[ $(cat html | wc -l) -gt 20 ]]; then
#  echo "Medusa Has No Password On $ip:8081" >> /var/plexguide/nopassword
#  fi
#}

# reset
echo -n "" > /var/plexguide/nopassword

# only test passwords for docker containers that are running
applist=$(docker ps | awk '{print $NF}' | grep -v NAME)
for app in $applist; do $app &>/dev/null; done

rm -r html

exit 0
