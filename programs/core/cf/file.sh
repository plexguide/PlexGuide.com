#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
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
  echo ""
  echo "-------------------------------------------------------------"
  echo "SYSTEM MESSAGE: Please Read the Following Information"
  echo "-------------------------------------------------------------"
  echo ""
  echo "Welcome to the PG CloudFlare Automatic Deployment Interface!"
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
      read -n 1 -s -r -p "API Set! Thank You! Press [ANY KEY] to Continue "
      echo "";
    fi
  done

  echo ""
  echo "--------------------------------------------------------"
  echo "SYSTEM MESSAGE: Complete - Info Stored! Exiting!"
  echo "--------------------------------------------------------"
  echo ""
  touch /var/plexguide/cloudflare.set
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
