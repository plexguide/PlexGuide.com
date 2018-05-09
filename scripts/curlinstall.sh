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
echo " --------------------------------------------------------------------- ";
echo " [ ! ]          C A U T I O N!           !C U I D A D O!          [ ! ]";
echo " --------------------------------------------------------------------- ";
echo "";
echo ""THIS SOFTWARE IS PROVIDED \"AS IS\" AND ANY EXPRESSED OR IMPLIED"";
echo "WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES"
echo "OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED."
echo "IN NO EVENT SHALL THE PROJECT MAINTAINERS OR PROJECT CONTRIBUTORS BE"
echo "LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,"
echo "OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF"
echo "SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS"
echo "INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN"
echo "CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)"
echo "ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF"
echo "ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. "
echo "";
echo "";
echo " Installation of this software is subject to your acceptance of"
echo "  these terms."
echo "";
# read: safe shell input check. non-negated answer continues, else aborts.
read -p "Do you accept these terms? (Y/n)" -n 1 -r
echo    # move cursor to a new line
echo ""
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "ABORTING due to user input. The above terms must be accepted in"
    echo "order to proceed with the installation. Now exiting."
    echo "";
    exit 1;
else
    echo "";# leave if statement and continue.
fi
echo "";
echo "";
echo "This script is about to *UPDATE* AND *UPGRADE* your OS. It is highly "
echo "  recommended that you deploy this on a new server, and not an existing"
echo "  one you may already be using. Running upgrades on an existing"
echo "  in-production server may break your environment and pre-existing setup"
echo "  of software, programs, scripts, applications, etc."
echo "";
echo "";
# read: safe shell input check. non-negated answer continues, else aborts.
read -p "Would you like to proceed updating and upgrading your OS and ALL packages? " -n 1 -r
echo    # move cursor to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "";
    echo "";
    echo "ABORTING per user request.";
    echo "";
    echo "";
    exit 1;
else
    echo "";# leave if statement and continue.
fi
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get full-upgrade -y
sudo apt-get install dialog git unzip wget whiptail -y
sudo rm -r /opt/plexguide
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/sc*/ins*
clear
echo "To deploy this Script anytime, type: plexguide"
echo "";
