#!/bin/bash

# Copied from https://github.com/Radarr/Radarr/wiki/Common-Problems on August 19, 2018
# Modified for Sonarr variables instead of Radarr variables

if [ -d "$sonarr_episodefile_sourcefolder" ] && [ "$(basename $sonarr_episodefile_sourcefolder)" = "deluge_extracted" ] ; then
	/bin/rm -rf $sonarr_episodefile_sourcefolder
fi 