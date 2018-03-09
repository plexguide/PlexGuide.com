## Current Changes (ACTIVE)
Current Changes will continued to be modified as known - (D) Dev (B#) Beta Version Update

### [5.061] BETA & DEV Version

#### Added
- (B1) Mass Restore: Traefik file is chmod to 0600 to prevent file permission issues (Reported By: Flicker-Rate)
- (B1) Enabling System Health Monitoring (Credit: EasternPA)
- (B1) Dialog asks for your username and email
- (B1) Added New Menu to Settings Incase You Have To Change
- (D) Can type your own new custom plex tag (useful for certain version, or if newest plex is bugged)
- (D) New Menus for Plex Install with Checks including asking for if user has remote server

#### Changed
- (B1) Mass Restore: User is notified to deploy each app after a mass restore (Reported By: Flicker-Rate)
- (B1) PlexDrive Fix (Credit: budman17r)
- (D) Overhauled Plex Install System

#### Removed
- (B1) Ansible asking you about domain and email, prevents stopping midinstalls (or babysitting to wait around)
- (D) Removed one useless press enter during ansible install of plex
- (D) Removed Use Plex Menus

#### Known Issues
- pyload is not working
- turnin off ports may not work in settings <<< might be fixed (have to test more)
- nextcloud not working
- SABNZBD https:// maybe not working?
-------------------------------------------------------

## Past Changes
Historical Documented Changes will be stored as below.

#### [5.060]

#### Added
- Added Settings Menu
- pgdev command; allows you to automatically to update to latest pgdev without being prompted
- Added minor script to display ending info rather than having to copy all over the place
- Ability to Force HTTPS:// only to apps or allow HTTP:// or HTTPS:// (new installs, default is http:// & https://
- Added option to go back to Main menu in the Service menu
- Added Cron Jobs Daily our Weekly to Installs
  - Will attempt to offer daily or weekly options
  - Weekly might be best for plex due to it's size and possibly cutting out for the time it's backing up
- Selecting none for Cron Job will remove it if there is one!

#### Changed
- Removed Bad Flags - PlexDrive / reported by Petitor
- Front Menu Layout
- Solo Backup & Restore Formatted To New Menu
  - Put Failsafes in place to prevent accidental backup
  - Check to see local data even exist
- Mass Backup & Restore Formatted To New Menu
  - Put Failsafes in place to prevent accidental backup
- Updated Service Status&Restart menus look
- Updated NCDU menu look

#### Removed
- Trashed Old Menus
- Wordpress for testing later

#### Known Issues
- pyload is not working
- turnin off ports may not work in settings

### [5.059]

#### Added
- New Command updates to pgupdata and plexguide
  - Emergency Mode: If for some reason plexguide is deleted, it will download the newest version so your not stuck
  - This requires an update to ensure new commands work

#### Changed
- For PD4, install MongoDB to version 3.4 from 3.6; believe 3.6 creates problems (3.4 was default prior)
- Changed NZBGET Container; prior one is bugged (not our fault lol)

#### Removed
- None

#### Known Issues
- NBGET Container is no good (not our fault, but pulling a new one to help you)
- For those using 5.058 or below; type sudo ansible-role commands (after you update)
  - If you don't, you'll never see the newer updates, you'll just see Developer 5.059 and Stable 5.058

### [5.058]

#### Added
- None

#### Changed
- Repaired SABNZBD; tags were off
- Reworked Menu Loadup
- Fixed Docker Completely

#### Removed
- None

#### Known Issues
- None

### [5.055 - 5.057] Bugged

#### Added
- None

#### Changed
- Fixed version of Docker; new one corrupt

#### Removed
- Old Rogue Script

#### Known Issues
- SABNZBD will not work in this version, repaired in 5.058
- Docker Will Not Load

### [5.053] Bugged

#### Added
- None

#### Changed
- Changed Portainer Output Display (never affected performance)
- Fixed Bugged Startup

#### Removed
- None


### [5.052] Bug Fix Update to 5.051

#### Added
- None

#### Changed
- Dialog: Updated Benchmark Menu
- Dialog: New Donation Menu
- Fixed Portainer Glitch

#### Removed
- Tossed Corresponding Above WhipTail Menu

### [5.051] Maintence Update to 5.050

#### Added
- Additonal Ability to pull latest update menu regardless of version

#### Changed
- None

#### Removed
- None

### [5.050]

#### Added
- Ability to always downloaded lastest download menu regardless of version

#### Changed
- None

#### Removed
- None

### [5.050]

#### Added
- New Installs - Ask for which version of PG they want to install (Stable/Developer)
- Ensure that new installs do results in exiting out of selection of Stable/Developer
- Ensure Dialog is installed prior to startup

#### Changed
- None

#### Removed
- None

### [5.049]

#### Added
- New Update Version System - Can select stable or develop versions
- Added menu precautions to prevent accidently upgrade
- Ansible role to install commands

#### Changed
- Command "sudo pgupdate" results in bringing up the menu
- More Menu Updates

#### Removed
- None

### [5.048]

#### Added
- None

#### Changed
- Added dialog to preinstall
- Put in a checker to check for dialog; not present... force installs
- Updated Installer info, adds sudo rm -r /opt/plexguide at beginning to prevent clash
- There was wildcard bug that didn't call install.sh, rather talked to the install folder causing pg to not be there
- (Not Finished) adding ability for developer edition / stable install

#### Removed
- None

### [5.046-5.047] BUGGED VERSION / FIXED NOW, 5.047 FIXES

#### Added
- New PreInstaller

#### Changed
- None

#### Removed
- Tossed Old PreInstaller

### [5.045]

#### Added
- Plex 4 or 5 Install selection

#### Changed
- Menu changes to new format
- Fixed TOML File (thanks razzamatazm)

#### Removed
- Tossing old menus

### [5.044]

#### Added
- Slowing adding new meus
- Mass Backup Installer
  - Mass Backup Installer also moves recent backup in gdrive to backup.old with a time stamp
- Mass Restore Installer
  - Mass Restore Installer can restore most recent and last 6 backups

#### Changed
- Fixed fast flash load up error (did not affect anything, but could be seen at times)
- Forced update to install "dialog"

#### Removed
- Slowly tossing old menus

### [5.043]

#### Added
- Force http to go https now. Rerun Traefik under programs > critical and will go into affect (required if not a new install)

#### Changed
- Resolving Issues for Subdomains!
- Updated Program menus to reflect new https:// for subdomains
- Improved Folder Ansible Deployment to prevent locks with existing mounts
- Improved Restore Script to untar ansible style over bash; delete local restore after complete
- Move plex transcode folder - no longer in backup, if running older version, redeploy plex and delete via rm -r /opt/appdata/plex/transcode

#### Removed
- None


### [5.042]

#### Added
- Ability to turn off ports (only use subdomains) and turn back on

#### Changed
- Bye NGINX-Reverse Proxy (wasn't used, but got rid of it from test menu)

#### Removed
- None

### [5.041]

#### Added
- PyLoad application was added (From b0ltn)
- Sickrage Added
- Added Glances Terminal Tool

#### Changed
- Minor fixes for https://
- Typo fixes for appdata
- Fixed major error with data, prior transfer service would stop too early

#### Removed
- None

### [5.040]

#### Added
- PG Upload Uncapped Beta Scripts (for unencrypted rclone version only)

#### Changed
- Fixed DelugeVPN download locations in Sonarr, Radarr, Lidarr, Mylar and CouchPotato
- Fixed name for Ombi and Heimdall in Backup/Restore scripts
- Order of Programs in Main Display
- Changed directory points in rutorrent (just redeploy rutorrent; make sure nothing is pending)

#### Removed
- Older Unused Scripts

### [5.039]

#### Warning
- Updating will require new backs ups if you have any - new .tar format is utilized over .zip
- If running 5.038 and below; ensure you:
  - Rerun plexdrive to activate new service (let it finish and reboot) (do not have enter tokens)
  - Rerun your version of rclone to activate the new service (may have to reboot) (do not have to enter tokens)

#### Added
- Added news Ansible Backup & Restore Works
- Fixed PD5 service start issue

#### Changed
- /mnt/rutorrent to /mnt/rutorrents in folder set up script
- Moved legacy backup to legacy selection for new Restore & Backup
- Media Programs menu fixed

#### Removed
- /mnt/rutorrent directory (when used with preinstaller)

### [5.038]
#### Added
- Install Ansible Toolbox
- Add Symoblic Links to assist the Program
- Adding New Ansible Backup, Restore - old becomes legacy and can be used until tranistion out
- Added Lidarr, CouchPotato, Organizr, Muximux & Heimdall to Backup/Restore scripts
- Added torrentvpn directory back into CouchPotato

#### Changed
- Switched to PlexDrive5 @designgears
- PG5 Configs
- Excluded Plex cache folder from Backup
- Edited emby to embyserver in Backup/Restore script
- Updated Service menus to reflect PlexDrive name change

#### Removed
- Old Ownership.sh file - no longer used

### [5.037]
#### Added
- CouchPotato Container Added (No Wiki Yet)

#### Changed
- Fixed RClone Menu Size in PlexGuide
- CouchPotato no longer starts up with the Wizard
- CouchPotato Blackhole turned off

#### Removed
- CouchPotato from the Menu

### [5.036]
#### Added
- SABNZBD: Automated location of /download and /incomplete folder; user no longer needs to setup
- SABNZBD: Automated location of /nzb and /admin folder; user no longer needs to setup

#### Changed
- SABNZBD: Ignore Samples turned on automatically for new installs
- SABNZBD: Direct unpack turned on for new installs
- SABNZBD: Automatically turns on Unwanted Extensions and Unwanted Exentions are automatically added
- SABNZBD: Try new NZB if fails automatically turned on automatically
- SABNZBD: Remove Password Protects RARS is now automatically turned on
- SABNZBD: All files will go into one folder for unpack
- SABNZBD: Remove dots from folders and replace with spaces
- SABNZBD: Automatically added cleanup extensions

#### Removed
- None

### [5.035]
#### Added
- NZBHydra2 to WatchTower
- Category Fields Locations for NZBGET for /tv /movie /music /ebook; users no longer have to add
- NCDU menu
- Fixed Movies category issues, new deployment results in /movies now instead of /Movies

#### Changed
- Tidied up VPN Torrent - old way menu
- Moved NCDU menu from Beta to Information menu
- Fixed removal of password issue when using NZBGET for the first time

#### Removed
- None

### [5.033 & 5.034]
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
- Added fix to install docker properly if it was uninstalled before

#### Removed
- None

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
