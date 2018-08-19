#!/bin/bash

# Copied from https://github.com/Radarr/Radarr/wiki/Common-Problems on August 19, 2018

if [ -d "$radarr_moviefile_sourcefolder" ] && [ "$(basename $radarr_moviefile_sourcefolder)" = "deluge_extracted" ] ; then
	/bin/rm -rf $radarr_moviefile_sourcefolder
fi 