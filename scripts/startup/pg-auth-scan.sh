#!/bin/bash
#ip=$1

sonarr () {
curl -m 5 -s $ip:8989 -o html \
  && grep -iq api html \
  && echo "Sonarr Has No Password On $ip:8989"
}

radarr () {
curl -m 5 -s $ip:7878 -o html \
  && grep -iq api html \
  && echo "Radarr Has No Password On $ip:7878"
}

lidarr () {
curl -m 5 -s $ip:8686 -o html \
  && grep -iq api html \
  && echo "Lidarr Has No Password On $ip:8686"
}

portainer () {
curl -m 5 -s $ip:9000/api/users/admin/check -o html \
  && grep -iq '{"err":"User not found"}' html \
  && echo "Portainer Has No Password On $ip:9000"
}

deluge () {
curl -d '{"method":"auth.login","params":["deluge"],"id":7}' \
  -H "Content-Type: application/json" \
   $ip:8112/json -m 5 -i -s -o html \
   && grep -iq 'Set-Cookie:' html \
   && echo "Deluge Has Default Password: "deluge" On $ip:8112"
}

rutorrent () {
curl -i -m 5 -s $ip:8999 -o html \
  && grep -iq '200 OK' html \
  && echo "ruTorrent Has No Password On $ip:8999"
}

nzbget () {
curl -i -s -m 5 $ip:6789 -o html \
  && grep -q 'Auth-Type=http' html \
  && echo "NZBget Has No Password On $ip:6789"
}

sabnzbd () {
curl -i -s -m 5 $ip:8080 -o html \
  && grep -q '200 OK' html \
  && echo "SABNZBD Has No Password On $ip:8080"
}

#for app in "portainer nzbget radarr sonarr"; do $app; done
#for app in $(docker ps | awk '{print $NF}' | grep -v NAME); do $app; done

for ip in $(cat plexopen); do
  nzbget
  rutorrent
  deluge
  sabnzbd
  portainer
  lidarr
  sonarr
  radarr
done

exit 0

