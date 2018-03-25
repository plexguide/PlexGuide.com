#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate
# URL:      https://plexguide.com
#
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

# this script checks for valid ssl certs on all running dockers

# stop program if dependencies not met
which nslookup &>/dev/null || exit 1
which openssl &>/dev/null || exit 1
which curl  &>/dev/null || exit 1
ping icanhazip.com -c 1 &>/dev/null || exit 1

if [[ ! -e /var/plexguide/basics.yes ]]; then
  exit 1; fi
if [[ ! -e /opt/appdata/plexguide/var.yml ]];then
  exit 1; fi

domain=$(cat /opt/appdata/plexguide/var.yml | grep 'domain:' -m 1 | awk '{print $2}')
realip=$(curl -s icanhazip.com)
echo -n '' > /var/plexguide/certchecker
echo -n '' > /var/plexguide/pingchecker

# don't test if users hasn't set a domain.
if [[ $domain == '' ]]; then
  exit 0
fi

if [[ $domain == 'domain.com' ]]; then
  exit 0
fi

ssl_check() {
            true | openssl s_client -showcerts -servername $1.$domain -connect $1.$domain:443 &>/dev/null | \
            openssl x509 -noout -text &>/dev/null \
            || echo "$1.$domain Does Not Have A Valid SSL Certificate." >> /var/plexguide/certchecker
}

ping_check() {
              nslookup=$(nslookup $1.$domain | grep 'Address:' | tail -1 | awk '{print $2}')
                if ! ping -c 1 $1.$domain &>/dev/null; then
                  echo "$1.$domain Cannot Be Reached." >> /var/plexguide/pingchecker
                elif [[ $nslookup != $realip ]]; then
                  echo "$1.$domain Does not point to this machine's real ip: $realip" >> /var/plexguide/pingchecker
                fi
}


applist=$(docker ps | awk '{print $NF}' | grep -v NAME | grep -v traefik | grep -v watchtower | grep -v plex)

# reset
echo -n '' > /var/plexguide/certchecker
echo -n '' > /var/plexguide/pingchecker

for app in $applist; do
  ping_check $app \
  && ssl_check $app
done

# ping error message
if [[ $(cat /var/plexguide/pingchecker) != '' ]]; then
tee <<-EOF >>/var/plexguide/pingchecker

This may be caused by misconfigured DNS settings on your registrar,
Or that your nameserver hasn't been updated (may take up to 30 minutes)
Or that you may be running a VPN or Proxy on your host.

1. Verify that A Records Are Pointed To $(curl -s icanhazip.com)
2. Verify That The Host (subdomain) Is Set To *
3. TTL is set to 1 minute.
EOF
fi

# invalid cert error message
if [[ $(cat /var/plexguide/certchecker) != '' ]]; then
tee <<-EOF >>/var/plexguide/certchecker

This may be caused by Traefik failing to validate DNS.
This could happen if you've recently added or changed the domain settings,
Or that you've recently added or changed the A records for your registrar.

1. Try Restarting Traefik by typing: docker restart traefik
2. View Traefik Logs by typing: docker logs traefik
3. Re-Install Traefik in the PlexGuide Menu.
EOF
fi
