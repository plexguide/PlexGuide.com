#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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
#bash -x foo.sh 2>&1 | tee log.file
plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --chunk-load-threads=8 --chunk-check-threads=8 --chunk-load-ahead=4 --chunk-size=10M --max-chunks=300 --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive --cache-file=/root/.plexdrive/cache.bolt /mnt/plexdrive
