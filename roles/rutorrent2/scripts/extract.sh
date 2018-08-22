#!/bin/bash

# Copied from https://github.com/Radarr/Radarr/wiki/Common-Problems on August 19, 2018
# the Radarr script was originally sourced from https://dev.deluge-torrent.org/wiki/Plugins/Execute

formats=(zip rar)
commands=([zip]="unzip -u" [rar]="unrar -r -o- e")
extraction_subdir='deluge_extracted'

torrentid=$1
torrentname=$2
torrentpath=$3

log()
{
    logger -t deluge-extractarchives "$@"
}

log "Torrent complete: $@"
cd "${torrentpath}"
for format in "${formats[@]}"; do
    while read file; do
        log "Extracting \"$file\""
        cd "$(dirname "$file")"
        file=$(basename "$file")
        # if extraction_subdir is not empty, extract to subdirectory
        if [[ ! -z "$extraction_subdir" ]] ; then
            mkdir "$extraction_subdir"
            cd "$extraction_subdir"
            file="../$file"
        fi
        ${commands[$format]} "$file"
    done < <(find "$torrentpath/$torrentname" -iname "*.${format}" )
done