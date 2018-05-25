#!/bin/bash
#
# [PlexGuide Curl Install]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   "Admin9705 - Deiteq, and YipYup"
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

function _polly() {
  local TITLE="YOU SHALL NOT PASS"
  local MESSAGE="Exiting due to user input"
  whiptail --title $TITLE --msgbox $MESSAGE 10 60
  clear
  curl -s parrot.live
}

function _start() {
  local TITLE="[ ! ]     C A U T I O N!     !C U I D A D O!     [ ! ]"
  local MESSAGE="THIS SOFTWARE IS PROVIDED \"AS IS\" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE PROJECT MAINTAINERS OR PROJECT CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. \n
  \n
  Installation of this software is subject to your acceptance of these terms."

  local START
  START=$(whiptail --title "$TITLE" --yes-button "I accept" --no-button "I do not accept" --yesno "$MESSAGE" 40 60 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    _verify
  else
    _polly
  fi
}

function _verify() {
  local TITLE"=Plexguide Installer"
  local MESSAGE="This script is about to *UPDATE* AND *UPGRADE* your OS. It is highly recommended that you deploy this on a new server, and not an existing one you may already be using. Running upgrades on an existing in-production server may break your environment and pre-existing setup of software, programs, scripts, applications, etc. \n \n Would you like to proceed updating and upgrading your OS and ALL packages?"
  local VERIFY
  VERIFY=$(whiptail --title "$TITLE" --yes-button "Continue" --no-button "Do not continue" --yesno "$MESSAGE" 40 60 3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    _SudoInstall
  else
    _polly
  fi
}

function _SudoInstall() {
  sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get full-upgrade -y
  sudo apt-get install dialog git unzip wget whiptail -y
  sudo rm -r /opt/plexguide
  sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
  sudo bash /opt/plexg*/sc*/ins*
  clear
  local TITLE="Exiting"
  local MESSAGE="To deploy this Script anytime, type: plexguide"
  whiptail --title $TITLE --msgbox $MESSAGE 40 60
}

function _Install() {
  local appPATH="$HOME/.config/plexguide"
  rm -rf "$appPATH"
  git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git "$appPATH"
  brew install dialog git unzip wget whiptail
}

# Start the install
_start
