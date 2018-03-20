#!/bin/bash
# this script checks for valid ssl certs on all running dockers

domain=$(cat /opt/appdata/plexguide/var.yml | grep 'domain:' -m 1 | awk '{print $2}')
realip=$(curl -s icanhazip.com)

# don't test if users hasn't set a domain.
if [[ $domain == '' ]]; then
  exit 0
fi

ssl_check() {
            true | openssl s_client -connect $1.$domain:443 2>/dev/null | \
            openssl x509 -noout -checkend 0 2>/dev/null \
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


applist=$(docker ps | awk '{print $NF}' | grep -v NAME | grep -v traefik | grep -v watchtower)

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
