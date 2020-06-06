#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
main() {
  local file=$1 val=$2 var=$3
  [[ -e $file ]] || printf '%s\n' "$val" >"$file"
  printf -v "$var" '%s' "$(<"$file")"
}

blockdeploycheck() {
  if [[ $(cat /pg/var/traefik.provider) == "NOT-SET" || $(cat /pg/var/server.domain) == "NOT-SET" || $(cat /pg/var/traefik/traefik.email) == "NOT-SET" ]]; then
    echo
    read -p 'Blocking Deployment! Must Configure Everything! | Press [Enter]' typed </dev/tty
    traefikstart
  fi
}

delaycheckinterface() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - DNS Delay Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: This enables a certain amount of time to be delayed before the
provider validates your Traefik container! Setting it too low may result
in the provider being unable to validate your traefik container, which may
result in MISSING the opportunity to validate your https:// certificates!

Delay the Traefik DNS Check for how many seconds? (Default 90)

EOF

  typed2=999999999
  while [[ "$typed2" -lt "30" || "$typed2" -gt "120" ]]; do
    echo "To quit, type >>> z or exit"
    read -p 'Type Number Between 30 through 120 | Press [Enter]: ' typed2 </dev/tty
    if [[ "$typed2" == "exit" || "$typed2" == "Exit" || "$typed2" == "EXIT" || "$typed2" == "z" || "$typed2" == "Z" ]]; then traefikstart; fi
    echo
  done

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 New DNS Delay Check Value: [$typed2] Seconds
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE 1: Make all changes first. Traefik must be deployed/redeployed for
this to take affect!

NOTE 2: When deploying Traefik, you will be required to wait at least $typed
seconds as a result of the check.

EOF
  echo "$typed2" >/pg/var/server.delaycheck
  read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty

}

destroytraefik() {
  docker stop traefik 1>/dev/null 2>&1
  docker rm traefik 1>/dev/null 2>&1

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik Container Destroyed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty
}

domaininterface() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Domain Name - Current Domain: $domain
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To quit, type >>> z or exit
EOF
  read -p 'Input Value | Press [Enter]: ' typed </dev/tty
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then traefikstart; fi
  if [[ $(echo ${typed} | grep "\.") == "" ]]; then

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Domain Name Invalid - Missing "." - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty
    domaininterface
    bash /opt/traefik/traefik.sh
    exit
  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Domain Name - Current Domain: $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Traefik must be deployed/redeployed for the domain name changes to
take affect!

EOF
  echo $typed >/pg/var/server.domain
  read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty

}

deploytraefik() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Deploy Traefik with the Following Values?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Domain Provider: $provider
Domain Name    : $domain
EMail Address  : $email

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  pnum=0
  mkdir -p /pg/var/prolist
  rm -rf /pg/var/prolist/* 1>/dev/null 2>&1

  ls -la "/opt/traefik/providers/$provider" | awk '{print $9}' | tail -n +4 >/pg/var/prolist/prolist.sh

  while read p; do
    let "pnum++"
    echo -n "${p} - "
    echo -n $(cat "/pg/var/traefik/$provider/$p")
    echo
  done </pg/var/prolist/prolist.sh
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  echo

  while true; do
    echo "Deploy Traefik?"
    read -p 'y or n? | Press [Enter]: ' typed2 </dev/tty
    if [[ "$typed2" == "n" || "$typed2" == "N" || "$typed2" == "No" || "$typed2" == "NO" ]]; then traefikstart; fi
    if [[ "$typed2" == "y" || "$typed2" == "Y" || "$typed2" == "Yes" || "$typed2" == "YES" ]]; then
      traefikbuilder
      traefikstart
    fi
    echo
  done

}

emailinterface() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Current EMail Address: $email
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To quit, type >>> z or exit
EOF
  read -p 'Input Value | Press [Enter]: ' typed </dev/tty
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then traefikstart; fi

  ### fix bug if user doesn't type .
  if [[ $(echo $typed | grep "\.") == "" ]]; then

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 EMail Invalid - Missing "." - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty
    emailinterface
    bash /opt/traefik/traefik.sh
    exit
  fi

  if [[ $(echo $typed | grep "\@") == "" ]]; then

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 EMail Invalid - Missing "@" - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty
    emailinterface
    bash /opt/traefik/traefik.sh
    exit

  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 New EMail Address: $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Make all changes first.  Traefik must be deployed/redeployed for
the email name changes to take affect!

EOF
  echo $typed >/pg/var/traefik/traefik.email
  read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty

}

layoutbuilder() {

  if [[ "$provider" == "NOT-SET" ]]; then layout=" "; fi
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Reverse Proxy Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Top Level Domain App: [$tld]
[2] Domain Provider     : [$provider]
[3] Domain Name         : [$domain]
[4] EMail Address       : [$email]
[5] DNS Delay Check     : [$delaycheck] Seconds
EOF

  # skips if no provider is set
  if [[ $(cat /pg/var/traefik.provider) != "NOT-SET" ]]; then
    # Generates Rest of Inbetween Interface

    pnum=5
    mkdir -p /pg/var/prolist
    rm -rf /pg/var/prolist/* 1>/dev/null 2>&1

    ls -la "/opt/traefik/providers/$provider" | awk '{print $9}' | tail -n +4 >/pg/var/prolist/prolist.sh

    # Set Provider for the Process
    provider7=$(cat /pg/var/traefik.provider)
    mkdir -p "/pg/var/traefik/$provider7"

    while read p; do
      let "pnum++"
      echo "$p" >"/pg/var/prolist/$pnum"
      echo "[$pnum] $p" >>/pg/var/prolist/final.sh

      # Generates a Not-Set for the Echo Below
      file="/pg/var/traefik/$provider7/$p"
      if [ ! -e "$file" ]; then
        filler="** NOT SET - "
        touch /pg/var/traefik/block.deploy
      else filler=""; fi

      echo "[$pnum] ${filler}${p}"
    done </pg/var/prolist/prolist.sh
  fi

  # If message.c exists due to incorrect working traefik, this will show
  if [ -e "/pg/data/plexguide/emergency/message.c" ]; then
    deployed="DEPLOYED - INCORRECTLY"
  fi

  # Last Piece of the Interface
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Deploy Traefik      : [$deployed]
[B] Destroy Traefik
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  # Standby
  read -p 'Type a Number | Press [Enter]: ' typed </dev/tty

  # Prompt User To Input Information Based on Greater > 4 & Less Than pnum++
  if [[ "$typed" -ge "6" && "$typed" -le "$pnum" ]]; then layoutprompt; fi

}

layoutprompt() {
  process5=$(cat /pg/var/prolist/final.sh | grep "$typed" | cut -c 5-)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Input Value - $process5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To quit, type >>> z or exit
EOF
  read -p 'Input Value | Press [Enter]: ' typed </dev/tty
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then traefikstart; fi

  echo "$typed" >"/pg/var/traefik/$provider7/$process5"
  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -p 'Information Stored | Press [Enter] ' typed </dev/tty

}

postdeploy() {
  tempseconds=$(cat /pg/var/server.delaycheck)
  delseconds=$((${tempseconds} + 10))
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby for repulling Core Apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
ansible-playbook /opt/traefik/repulls/clone.yml
sleep 2
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ✅ PASSED - repull Core Apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
 sleep 3

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby for Traefik Deployment Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE 1: Do NOT EXIT this interface. Please standby for validation checks!

NOTE 2: Standing by for [$tempseconds] + 10 seconds per the set DNS delay
check! When complete, Portainer will be rebuilt! If that passes,
then we will rebuild the rest of the containers!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  while [[ "$delseconds" -ge "1" ]]; do
    delseconds=$((${delseconds} - 1))
    echo -ne "StandBy - Traefik Validaiton Process: $delseconds Seconds  "'\r'
    sleep 1
  done

  tee <<-EOF


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Rebuilding Portainer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  ansible-playbook /opt/coreapps/apps/portainer.yml

  delseconds=10
  domain=$(cat /pg/var/server.domain)

  cname="portainer"
  if [[ -f "/pg/var/portainer.cname" ]]; then
    cname=$(cat "/pg/var/portainer.cname")
  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Portainer Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE 1: Do NOT EXIT this interface. Please standby for validation checks!

NOTE 2: Checking on https://${cname}.${domain}'s existance.
Please allow 10 seconds for portainer to boot up.

NOTE 3: Be aware that simple mistakes such as bad input, bad domain, or
not knowing what your doing counts for 75% of the problems.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  while [[ "$delseconds" -ge "1" ]]; do
    delseconds=$((${delseconds} - 1))
    echo -ne "StandBy - Portainer Validation Checks: $delseconds Seconds  "'\r'
    sleep 1
  done

  cname="portainer"
  if [[ -f "/pg/var/portainer.cname" ]]; then
    cname=$(cat /pg/var/portainer.cname)
  fi

  touch /pg/data/plexguide/traefikportainer.check
  wget -q "https://${cname}.${domain}" -O "/pg/data/plexguide/traefikportainer.check"

  # If Portainer Detection Failed
  if [[ $(cat /pg/data/plexguide/traefikportainer.check) == "" ]]; then
    rm -rf /pg/data/plexguide/traefikportainer.check

    tee <<-EOF


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Portainer Check: FAILED!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SMART TIP: Check Portainer Now! View the Traefik Logs!

Portainer  : https://${cname}.${domain}

REASON 1 - CloudFlare  : portainer is not set in the CNAME or A Records
REASON 2 - DelayValue  : Set too low - CF users reported using 90 to work
REASON 3 - DuckDNS     : Forgot to create a portainer or * - A Record
REASON 4 - Firewall    : Everything is blocked
REASON 5 - LetsEncrypt : LE HitLimit : check https://crt.sh/?q=${domain}
REASON 6 - LetsEncrypt : Planned Maintenance In Progress or service down (https://letsencrypt.status.io)
REASON 7 - User        : PTS Locally; Route is not enable to reach server
REASON 8 - User        : Bad values input or failed to read the wiki
REASON 9 - User        : Forgot to point DOMAIN to CORRECT IP ADDRESS

There are multiple reason for failure! Visit wiki or discord!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p 'Acknowledge Info | Press [Enter] ' name </dev/tty

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik Process Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SMART TIP: When fixed, rerun this process again!

NOTE 1: Possibly unable to reach subdomains
NOTE 2: Subdomains will provide insecure warnings

EOF

    read -p 'Try Again! Acknowledge Info | Press [Enter] ' name </dev/tty
    traefikstart
  fi

  tee <<-EOF


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Portainer - https://${cname}.${domain} detected!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  delseconds=4
  while [[ "$delseconds" -ge "1" ]]; do
    delseconds=$((${delseconds} - 1))
    echo -ne "StandBy - Rebuilding Containers in: $delseconds Seconds  "'\r'
    sleep 1
  done

  docker ps -a --format "{{.Names}}" >/pg/var/container.running

  # Containers to Exempt
  sed -i -e "/traefik/d" /pg/var/container.running
  sed -i -e "/watchtower/d" /pg/var/container.running
  sed -i -e "/wp-*/d" /pg/var/container.running # Exempt WP DataBases
  sed -i -e "/x2go*/d" /pg/var/container.running
  sed -i -e "/authclient/d" /pg/var/container.running
  sed -i -e "/dockergc/d" /pg/var/container.running
  sed -i -e "/oauth/d" /pg/var/container.running

  sed -i -e "/portainer/d" /pg/var/container.running # Already Rebuilt

  count=$(wc -l </pg/var/container.running)
  ((count++))
  ((count--))

  tee <<-EOF


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Traefik - Rebuilding Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 3
  for ((i = 1; i < $count + 1; i++)); do
    app=$(sed "${i}q;d" /pg/var/container.running)
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Traefik - Rebuilding [$app]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    echo "$app" >/tmp/program_var
    sleep 1.5

    #Rebuild Depending on Location
    if [ -e "/opt/coreapps/apps/$app.yml" ]; then ansible-playbook /opt/coreapps/apps/$app.yml; fi
    if [ -e "/opt/communityapps/$app.yml" ]; then ansible-playbook /opt/communityapps/apps/$app.yml; fi

  done

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '✅️ Traefik - Containers Rebuilt! Acknowledge Info | Press [Enter] ' name </dev/tty

}

providerinterface() {

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Select a Provider
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  pnum=0
  mkdir -p /pg/var/prolist
  rm -rf /pg/var/prolist/* 1>/dev/null 2>&1

  ls -la "/opt/traefik/providers" | awk '{print $9}' | tail -n +4 >/pg/var/prolist/prolist.sh

  while read p; do
    let "pnum++"
    echo "$p" >"/pg/var/prolist/$pnum"
    echo "[$pnum] $p" >>/pg/var/prolist/final.sh
  done </pg/var/prolist/prolist.sh

  cat /pg/var/prolist/final.sh
  echo
  typed2=999999999
  while [[ "$typed2" -lt "1" || "$typed2" -gt "$pnum" ]]; do
    echo "[Z] Exit"
    echo ""
    read -p 'Type Number | Press [Enter]: ' typed2 </dev/tty
    if [[ "$typed2" == "exit" || "$typed2" == "Exit" || "$typed2" == "EXIT" || "$typed2" == "z" || "$typed2" == "Z" ]]; then traefikstart; fi
    echo
  done
  echo $(cat /pg/var/prolist/final.sh | grep "$typed2" | cut -c 5- | awk '{print $1}' | head -n 1) >/pg/var/traefik.provider

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Provider Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Make all changes first.  Traefik must be deployed/redeployed for
this to take affect!

EOF
  read -p 'Acknowledge Info | Press [Enter] ' typed </dev/tty
}

traefikbuilder() {

  provider=$(cat /pg/var/traefik.provider)

  echo "

- name: 'Setting Traefik ENV'
  set_fact:
    pg_env:
      PUID: '1000'
      PGID: '1000'
      PROVIDER: $provider" | tee /opt/traefik/provider.yml 1>/dev/null 2>&1

  mkdir -p /pg/var/prolist
  rm -rf /pg/var/prolist/* 1>/dev/null 2>&1

  ls -la "/opt/traefik/providers/$provider" | awk '{print $9}' | tail -n +4 >/pg/var/prolist/prolist.sh

  while read p; do
    echo -n "      ${p}: " >>/opt/traefik/provider.yml
    echo $(cat "/pg/var/traefik/$provider/$p") >>/opt/traefik/provider.yml
  done </pg/var/prolist/prolist.sh

  if [[ $(docker ps --format '{{.Names}}' | grep traefik) == "traefik" ]]; then
    docker stop traefik 1>/dev/null 2>&1
    docker rm traefik 1>/dev/null 2>&1
  fi

  file="/pg/data/traefik"
  if [ -e "$file" ]; then rm -rf /pg/data/traefik; fi

  ansible-playbook /opt/traefik/traefik.yml

  postdeploy
}

traefikpaths() {
  mkdir -p /pg/var/traefik
}

traefikstatus() {
  if [ "$(docker ps --format '{{.Names}}' | grep traefik)" == "traefik" ]; then
    deployed="DEPLOYED"
  else deployed="NOT DEPLOYED"; fi
}
