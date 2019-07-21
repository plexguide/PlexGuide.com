#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  LooseSeal2
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh

# vars
program=$(cat /tmp/program_var)
domain=$(cat "/var/plexguide/server.domain")

variable /var/plexguide/"$program".cname "$program"

variable /var/plexguide/"$program".port ""

# FIRST QUESTION
question1() {
    cname=$(cat "/var/plexguide/$program.cname")
    port=$(cat "/var/plexguide/$program.port")
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ $program - Set subdomains & ports
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚡ Reference: http://$program.pgblitz.com

EOF
    if [[ $port != "" ]]; then
        tee <<-EOF
External Url:     https://$cname.$domain:$port
EOF
    else
        tee <<-EOF
External Url:     https://$cname.$domain
EOF
    fi

    tee <<-EOF

[1] Change subdomain
[2] Change external port

EOF

    if [[ $port != "" ]]; then
        tee <<-EOF
[A] Use https://$cname.$domain:$port
EOF
    else
        tee <<-EOF
[A] Use https://$cname.$domain
EOF
    fi
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
    if [[ "$typed" == "A" || "$typed" == "a" ]]; then
        exit
    elif [ "$typed" == "1" ]; then
        read -p "🌍 Type subdomain to use for $program | Press [ENTER]: " typed </dev/tty

        if [[ "$typed" == "" ]]; then
            badinput1
        else
            if ! [[ "$typed" =~ ^(([a-zA-Z0-9_]|[a-zA-Z0-9_][a-zA-Z0-9_\-]*[a-zA-Z0-9_])\.)*([A-Za-z0-9_]|[A-Za-z0-9_][A-Za-z0-9_\-]*[A-Za-z0-9_](\.?))$ ]]; then
                badinput1
            else
                echo "$typed" >"/var/plexguide/$program.cname"
                question1
            fi
        fi
    elif [ "$typed" == "2" ]; then
        read -p "🌍 Type port 1025-65535 to use for $program | blank for default | Press [ENTER]: " typed </dev/tty
        if [[ "$typed" == "" ]]; then
            echo "" >"/var/plexguide/$program.port"
        else
            if ! [[ "$typed" =~ ^[0-9]+$ && "$typed" -ge 1025 && "$typed" -le 65535 ]]; then
                badinput1
            else
                echo "$typed" >"/var/plexguide/$program.port"
            fi
        fi
        question1
    else badinput1; fi
}

question1

manualuser() {
    while read p; do
        echo "$p" >"/var/plexguide/$program.cname"
    done </var/plexguide/pgbox.buildup
    exit
}
