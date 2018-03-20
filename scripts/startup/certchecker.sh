#!/bin/bash
# this script checks for valid ssl certs on all running dockers

domain=$(cat /opt/appdata/plexguide/var.yml | grep 'domain:' -m 1 | awk '{print $2}')
ssl_check() {
            true | openssl s_client -connect $1.$domain:443 2>/dev/null | \
            openssl x509 -noout -checkend 0 2>/dev/null \
            || cat <<"EOF"
            lorem ipsum dolor asjsdf
            lorem ipsum dolor blah blah $1.$domain
            cert failed whatever
            EOF
}

ping_check() {
              ping -c 1 $1.$domain &>/dev/null \
              || cat << "EOF"
              lorem ipsum dolor blah blah $1.$domain
              ping failed whatever
              EOF
}

applist=$(docker ps | awk '{print $NF}' | grep -v NAME)

for app in $applist; do
  ping_check $app \
  && ssl_check $app
done
