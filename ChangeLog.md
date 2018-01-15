## Current Changes
Current Changes will continued to be modifed as known.

### [5.031] Actively Working
#### Added
- Traefik Reverse Proxy - Only http:// works... but works. https:// for it down the road.

#### Changed
- None

#### Removed
- NGINX-Proxy - It's the program; it crashes and loses track of everything!

-------------------------------------------------------
## Past Changes
Historical Documented Changes will be stored as below.

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
