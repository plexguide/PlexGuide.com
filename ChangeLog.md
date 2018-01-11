## Current Changes
Current Changes will continued to be modifed as known.

### [5.0.027] Actively Working
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

-------------------------------------------------------
## Past Changes
Historical Documented Changes will be stored as below.

### [5.0.026] 
#### Added
- Added Watchtower / Updates Containers

#### Changed
- Fixed Backup Script; was an if instead of an fi
- Fixed Watch Tower / Accidently Took the Place of Sonnar (naming scheme)

#### Removed
- Unnecessary Menu Code

--------------------------------------------------------

### [5.0.025]
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

### [5.0.024]
#### Added
- Set CPU to work at Performance, OnDemand, or Conservative Mode

#### Changed
- Startup Menu - Improved Menu Size

#### Removed
- None
