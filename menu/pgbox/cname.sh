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

variable "/var/plexguide/$program.cname" "$program"

variable "/var/plexguide/$program.port" ""

# FIRST QUESTION
question1() {
    cname=$(cat "/var/plexguide/$program.cname")
    port=$(cat "/var/plexguide/$program.port")
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Customize subdomains & ports for $p
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
[3] Use $cname:$port
EOF
    else
        tee <<-EOF
[3] Use $cname    
EOF
    fi
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
    if [ "$typed" == "3" ]; then
        exit
    elif [ "$typed" == "1" ]; then
        read -p "🌍 Type subdomain to use for $program | Press [ENTER]: " typed </dev/tty
        echo "$typed" >/var/plexguide/$program.cname
        question1
    elif [ "$typed" == "2" ]; then
        read -p "🌍 Type external port to use for $program | Press [ENTER]: " typed </dev/tty
        echo "$typed" >/var/plexguide/$program.port
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
