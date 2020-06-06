#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###
mkdir -p /pg/var/
if [[ -e "/pg/var/pg.noinstall" ]]; then pgcmd=true; else pgcmd=false; fi
rm -rf /pg/var/pg.noinstall
################################################################################
if [[ ! -e "/usr/bin/docker" ]]; then echo "" > /bin/docker; else rm -rf /bin/docker; fi
if [[ -e "/bin/docker" ]]; then chmod 0755 /bin/docker && chown 1000:1000 /bin/docker; fi
################################################################################
if [[ "$pgcmd" != "true" ]]; then
rm -rf /pg/mods
rm -rf /pg/tmp/checkout
git clone -b alpha --single-branch https://github.com/plexguide/PlexGuide.com.git /pg/tmp/checkout
mv -f /pg/tmp/checkout/mods /pg; fi
################################################################################
fpath="/pg/mods/functions"; source "$fpath"/install_sudocheck; install_sudocheck
################################################################################
bash "$fpath"/.create.sh; source "$fpath"/.master.sh
################################################################################

#$echo "COMMAND IS - $pgcmd"
if [[ "$pgcmd" != "true" ]]; then

common_message "🌎 INSTALLING: PlexGuide.com GNUv3 License" "By Installing PlexGuide, you are agreeing to the terms and conditions of the
GNUv3 License!

If you have a chance to donate, please visit https://donate.plexguide.com

At anytime you can Press CTRL+Z to STOP the Installation"
common_timer_v2 "1" ## set back to 5
fi

################################################################################
mkdir -p /pg/var/install/
install_check

common_install install_folders
install_cmds
#install_oldpg ## not need unless we come out with PG11+ that requires a block
common_install install_drivecheck
common_install install_webservercheck
common_install install_oscheck
common_install install_basepackage
common_install install_pyansible
common_install install_dependency

# ansible-playbook /pg/mods/motd/motd.yml

common_install install_docker
common_install install_docker_start
common_install install_rclone
common_install install_mergerfs
common_install install_gcloud_sdk
common_install install_nvidia

############# DO NOT ACTIVE TILL PGUNION
#common_header "⌛ INSTALLING: MergerFS Update"; sleep 2
#ansible-playbook /pg/mods/ymls/pg.yml --tags mergerfsupdate

################################################################################
bash /pg/mods/start/start.sh
exit
