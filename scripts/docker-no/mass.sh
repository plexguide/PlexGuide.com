#!/bin/bash 

#set path for docker items
VARMENU1="/opt/plexguide/scripts/docker-no/"

        bash "$VARMENU1"dep.sh
        bash "$VARMENU1"ssh.sh  
        bash "$VARMENU1"plex.sh
        bash "$VARMENU1"sabnzbd.sh
        bash "$VARMENU1"sonarr.sh
        bash "$VARMENU1"radarr.sh


#set path for non-docker items
VARMENU2="/opt/plexguide/scripts/docker"
        
	bash "$VARMENU2"docker.sh
        bash "$VARMENU2"ombi.sh
        bash "$VARMENU2"emby.sh
        bash "$VARMENU2"netdata.sh
        bash "$VARMENU2"plexpy.sh
        bash "$VARMENU2"muximux.sh
        bash "$VARMENU2"wordpress.sh
        bash "$VARMENU2"rutorrent.sh