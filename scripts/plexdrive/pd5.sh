plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --chunk-load-threads=8 --chunk-check-threads=8 --chunk-load-ahead=4 --chunk-size=10M --max-chunks=300 --fuse-options=allow_other,read_only --config=/root/.plexdrive --cache-file=/root/.plexdrive/cache.bolt /mnt/plexdrive >> /opt/appdata/plexdrive.info


