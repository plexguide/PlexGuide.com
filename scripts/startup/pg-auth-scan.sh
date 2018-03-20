#!/bin/bash

# sanity check, then get ip
ping icanhazip.com -c 1 &>/dev/null || exit 1
if [[ ! -e /var/plexguide/basics.yes ]]; then
  exit 1; fi
ip=$(curl -s icanhazip.com)


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

# reset
echo "" > /var/plexguide/nopassword

# only test passwords for docker containers that are running
applist=$(docker ps | awk '{print $NF}' | grep -v NAME)
for app in $applist; do $app &>/dev/null; done


exit 0
