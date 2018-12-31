#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
  file="/var/plexguide/cloudflare.api"
  if [ ! -e "$file" ]; then
    echo "NOT-SET" > /var/plexguide/cloudflare.api
    rm -rf /var/plexguide/cloudflare.set 1>/dev/null 2>&1
  fi

  file="/var/plexguide/cloudflare.email"
  if [ ! -e "$file" ]; then
    echo "NOT-SET" > /var/plexguide/cloudflare.email
    rm -rf /var/plexguide/cloudflare.email 1>/dev/null 2>&1
  fi

  file="/var/plexguide/cloudflare.set"
  if [ ! -e "$file" ]; then
    cfset=$(echo "CF NOT Configured")
  else
    cfset=$(echo "CF Configured")
  fi

  echo ""
  echo "-------------------------------------------------------------"
  echo "SYSTEM MESSAGE: Please Read the Following Information"
  echo "-------------------------------------------------------------"
  echo ""
  echo "Welcome to the PG CloudFlare Automatic Deployment Interface!"
  echo "STATUS - $cfset"
  echo ""
  echo "NOTE 1: Input Your CloudFlare EMail Address & API Next"
  echo "NOTE 2: You Must Deploy CloudFlare via Traefik First!"
  echo "NOTE 3: Interface Will Improve with Next Traefik Rewrite!"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  echo ""
  echo ""
  read -p "Set or Change Current CloudFlare Info (y/n)? " -n 1 -r
  echo    # move cursor to a new line

  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo ""
    echo "--------------------------------------------------------"
    echo "SYSTEM MESSAGE: [Y] Key was NOT Selected - Exiting!"
    echo "--------------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo "";
      exit 1;
  fi

  break=no
  while [ "$break" == "no" ]; do
  echo ""
  echo "-------------------------------------------------"
  echo "SYSTEM MESSAGE: Set the CF E-Mail Address"
  echo "-------------------------------------------------"
  echo ""
  read -p 'Type Your CF E-Mail Address (all lowercase): ' typed
  #typed=typed+0
    echo ""
    echo "-------------------------------------------------"
    echo "SYSTEM MESSAGE: CF E-Mail - $typed"
    echo "-------------------------------------------------"
    echo ""
    read -p "Is Your E-Mail Address Correct (y/n)? " -n 1 -r

    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      echo ""
      echo "--------------------------------------------------------"
      echo "SYSTEM MESSAGE: [Y] Key was NOT Selected"
      echo "--------------------------------------------------------"
      echo ""
      echo "Must Set Up an E-Mail Address! Restarting Again!"
      echo
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo "";
    else
      echo $typed > /var/plexguide/cloudflare.email
      email=$typed
      break=yes
      echo "";
    fi
  done

  break=no
  while [ "$break" == "no" ]; do
  echo ""
  echo "-------------------------------------------------"
  echo "SYSTEM MESSAGE: Set the CF API Key (Address)"
  echo "-------------------------------------------------"
  echo ""
  read -p 'Type Your CF API Key (case senstive): ' typed
  #typed=typed+0
    echo ""
    echo "-------------------------------------------------"
    echo "SYSTEM MESSAGE: CF API - $typed"
    echo "-------------------------------------------------"
    echo ""
    read -p "Is Your CF API Address Correct (y/n)? " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      echo ""
      echo "--------------------------------------------------------"
      echo "SYSTEM MESSAGE: [Y] Key was NOT Selected"
      echo "--------------------------------------------------------"
      echo ""
      echo "Must Set Up an API Address! Restarting Again!"
      echo
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo "";
    else
      echo ""
      echo "--------------------------------------------------------"
      echo "SYSTEM MESSAGE: SET Informatinon"
      echo "E-Mail  - $email"
      echo "API Key - $typed"
      echo "--------------------------------------------------------"
      echo ""
      echo $typed > /var/plexguide/cloudflare.api
      break=yes
      touch /var/plexguide/cloudflare.set
      read -n 1 -s -r -p "API Set! Thank You! Press [ANY KEY] to Continue "
      echo ""
      echo "" && read -n 1 -s -r -p "We Must Rebuild Your Containers! Press [ANY] Key!"
      bash /opt/plexguide/roles/traefik/scripts/rebuild.sh
      echo "" && read -n 1 -s -r -p "Containers Rebuilt! Press [ANY] Key to Continue!"
      echo "";
    fi
  done
