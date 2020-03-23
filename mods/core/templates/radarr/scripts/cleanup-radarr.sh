#!/bin/bash

if [ -d "$radarr_moviefile_sourcefolder" ] && [ "$(basename $radarr_moviefile_sourcefolder)" = "deluge_extracted" ] ; then
    /bin/rm -rf $radarr_moviefile_sourcefolder
fi