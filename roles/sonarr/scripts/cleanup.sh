#!/bin/bash

if [ -d "$sonarr_episodefile_sourcefolder" ] && [ "$(basename $sonarr_episodefile_sourcefolder)" = "deluge_extracted" ] ; then
	/bin/rm -rf $sonarr_episodefile_sourcefolder
fi 