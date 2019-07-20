#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

rolename=$(cat /var/plexguide/pgcloner.rolename)
roleproper=$(cat /var/plexguide/pgcloner.roleproper)
projectname=$(cat /var/plexguide/pgcloner.projectname)
projectversion=$(cat /var/plexguide/pgcloner.projectversion)
startlink=$(cat /var/plexguide/pgcloner.startlink)

mkdir -p "/opt/$rolename"

initial() {
    ansible-playbook "/opt/plexguide/menu/pgcloner/corev2/primary.yml"
    echo ""
    echo "💬  Pulling Update Files - Please Wait"
    file="/opt/$rolename/place.holder"
    waitvar=0
    while [ "$waitvar" == "0" ]; do
        sleep .5
        if [ -e "$file" ]; then waitvar=1; fi
    done
    bash /opt/${rolename}/${startlink}
}

custom() {
    mkdir -p "/opt/$rolename"
    ansible-playbook "/opt/plexguide/menu/pgcloner/corev2/personal.yml"

    echo ""
    echo "💬  Pulling Update Files - Please Wait"
    file="/opt/$rolename/place.holder"
    waitvar=0
    while [ "$waitvar" == "0" ]; do
        sleep .5
        if [ -e "$file" ]; then waitvar=1; fi
    done
    bash /opt/${rolename}/${startlink}
}

mainbanner() {
    clonerinfo=$(cat /var/plexguide/pgcloner.info)
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 $roleproper | 📓 Reference: $rolename.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$clonerinfo

[1] Utilize $roleproper - PGBlitz's
[2] Utilize $roleproper - Personal (Forked)

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p 'Type a Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)
        initial
        ;;
    2)
        variable /var/plexguide/$rolename.user "NOT-SET"
        variable /var/plexguide/$rolename.branch "NOT-SET"
        pinterface
        ;;
    z)
        exit
        ;;
    Z)
        exit
        ;;
    *)
        mainbanner
        ;;
    esac
}

pinterface() {

    user=$(cat /var/plexguide/$rolename.user)
    branch=$(cat /var/plexguide/$rolename.branch)

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 $roleproper | 📓 Reference: $rolename.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 User: $user | Branch: $branch

[1] Change User Name & Branch
[2] Deploy $roleproper - Personal (Forked)

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    read -p 'Type a Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 IMPORTANT MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Username & Branch are both case sensitive! Make sure to check for the
default or selected branch!

NOTE: Forks are maintained only by YOU!
You will not receive updates from PGBlitz on your fork.
This means you will not receive bug fixes and new features on your fork!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -p 'Username | Press [ENTER]: ' user </dev/tty
        read -p 'Branch   | Press [ENTER]: ' branch </dev/tty
        echo "$user" >/var/plexguide/$rolename.user
        echo "$branch" >/var/plexguide/$rolename.branch
        pinterface
        ;;
    2)
        existcheck=$(git ls-remote --exit-code -h "https://github.com/$user/$projectname" | grep "$branch")
        if [ "$existcheck" == "" ]; then
            echo
            read -p '💬 Exiting! Forked Version Does Not Exist! | Press [ENTER]: ' typed </dev/tty
            mainbanner
        fi
        custom
        ;;
    z)
        exit
        ;;
    Z)
        exit
        ;;
    *)
        mainbanner
        ;;
    esac
}

# FUNCTIONS END ##############################################################
echo "" >/tmp/output.info
mainbanner
