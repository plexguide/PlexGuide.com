## Current Changes
Current Changes will continued to be modifed as known.

### [5.034] Actively Working
#### Added
- Added ncdu to preinstall

#### Changed
- Fixed RuTorrent Subdomain to rutorrent.yourdomain.com
- Fixed Tautulli Sudomain to point correctly to tautulli.yourdomain.com / was plepy.yourdomain.com before
- Improved Reverse Proxy Guide: https://plexguide.com/threads/reverse-proxy-basic-instructions.259/
- Updated Emby Image
- Temp Removed /// Updates CTop to .7 | prior one was removed and caused freezing
- Cleaned Up Random Messages
- Pre-Installer 25 second wait removed if docker was installed before
- Added addiontal information for people who have issues where their server cannot be seen by network (added to guide)
    - https://plexguide.com/threads/plex-configuration.307/
- Fixed rclone-en uid/gid issue for /mnt/encrypt

#### Removed
- None

-------------------------------------------------------
## Past Changes
Historical Documented Changes will be stored as below.

### [5.032]
#### Added
- Added ExecStop to RClone Encrypted install
- Added recurse=true to some containers
- Added EBook Stuff - Not Implement Yet (Pentagons)

#### Changed
- NZBHydra2 to Hotio Image (DesignGears)
- Medusa volume from /mnt to /mnt/medusa/downloads
- Traefik is at version 1.5 (DesignGears)
- Updated RClone Move to delete Folders empty folder after each sync (MrWednesday)
  - To Apply Fix, rerun rclone (the version you had); when it loads, type Q (quit) and press ENTER; that's it!

#### Removed
- None

### [5.031]
#### Added
- Traefik Reverse Proxy - Only http:// works... but works. https:// for it down the road.
- Added labels to Plex and Emby so Traefik binds with the correct ports
- Added Troubleshooting Guide for Rclone & Plexdrive4 Services to the Wiki pages

#### Changed
- Swapped Proxy https:// for Subdomain http:// in program menus
- Moved NGINX-Proxy to Beta Testing menu for those that want to tinker
- Put a new way to grab your actually CIDR for use with Torrent VPN's - please re-run var setup from the Beta menu if you plan to reinstall either
- (Thanks DesignGears) Expose plex properly!

#### Removed
- NGINX-Proxy - It's the program; it crashes and loses track of everything!

### [5.030]
#### Added
- NGINX Line Fix
- NZBHyra2 (Added By DesignGears)
- Menu OverHaul
- Automated WebTools (Thanks Bate for Writeup To Help)
- DelugeVPN & rTorrentVPN are now in the Beta Testing menu
- Adding VNC Docker Server Image for Temp Uses
- Nonredirect tags (requires recreating container) useful if https:// doesn't load

#### Changed
- Forced Pre-Install Update
- Service Status & Restore menu style

#### Removed
- PlexGuide Network From Plex

### [5.028]
#### Added
- Patch 002
- Password request for future wordpress info and .htaccess files

#### Changed
- Patch 002 changes /opt/nginx-proxy to /opt/appdata/nginx-proxy

#### Removed
- None

### [5.027]
#### Added
- SSL Deployment
- Version Update Control
- Patch Management Depending on Version
- Radio Menu for Advanced Benchmark Test
- Lidarr to Beta (Thanks DesignGears)

#### Changed
- Fixed Restore Script; was an if instead of an fi
- Fixed NetData, would remove portainer on install
- Improved Initial Install Instructions on Read Me
- Menu Code Cleanup
- Modifications to script to allow SSL

#### Removed
- Traefik

### [5.026]
#### Added
- Added Watchtower / Updates Containers

#### Changed
- Fixed Backup Script; was an if instead of an fi
- Fixed Watch Tower / Accidently Took the Place of Sonnar (naming scheme)

#### Removed
- Unnecessary Menu Code

--------------------------------------------------------

### [5.025]
#### Added
- Add v2 DockerFix
  - Reboots all containers
  - Ensures other containers see unionfs/plexdrive4 properly

#### Changed
- Installs new V2 and removes old v1 automatically
- Requires forced pre-install for transition

#### Removed
- Old v1 DockerFix
  - Rebooted only particular containers
  - Timing issues resulted in containers sometimes losing unionfs/plexdrive4

-------------------------------------------------------

### [5.024]
#### Added
- Set CPU to work at Performance, OnDemand, or Conservative Mode

#### Changed
- Startup Menu - Improved Menu Size

#### Removed
- None
