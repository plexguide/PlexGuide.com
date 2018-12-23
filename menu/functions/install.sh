#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
starter () {
  abc="/var/plexguide"

}

core () {
    touch /var/plexguide/pg.$1.stored
    start=$(cat /var/plexguide/pg.$1)
    stored=$(cat /varplexguide/pg.$1.stored)

if [ "$start" != "$stored" ]; then
  $1
  rolestored; fi
}

rolestored () {
  cat /var/plexguide/pg.$1 > /var/plexguide/pg.$1.stored
}

alias () {
  ansible-playbook /opt/plexguide/menu/$1/${1}.yml
}
