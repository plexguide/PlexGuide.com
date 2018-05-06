## Current Changes (ACTIVE)
Current Changes will continued to be modified as known - (D) Dev (B#) Beta Version Update

### [5.078] (Beta, Release Candiate & DEV)

- None

-------------------------------------------------------
## Past Changes
Historical Documented Changes will be stored as below.

#### [5.076-5.077] - 6 May 2018

- Notes
  - Plex CloudFlare (@lunchingfriar)
  - Netdata Fixed
  - NextCloud Fixed
  - HD Multi Edition Released (Needs some work)
  - Stopped First Time Install, recall of menu
  - Tons of startup related bug fixes

- Added
  - Airsonic to Restore menu
  - TorrentVPN & SickRage to Backup & Restore menus

- Changed
  - Moved TorrentVPN from Beta to Torrent Menu

#### [5.075] - 3 May 2018

- Added
  - PG Cron Advanced
  - PG Multi-Image Menu
  - Repaired 4K Menu
  - Time To Menus / CronJob & Startup
  - New Way to Adjust time Via Settings and Cron Job Interface

- Changed
  - Better MP4 Repo (@zachawii)
  - Reworked PreInstaller
  - Fixed SAB port numbers
  - Stopped asking donation question if asked already once for preinstaller


#### [5.074] - 30 April 2018

- Better watchtower settings
- Watchtower improvements on the front page
- New Program - The Lounge
- Minor Bugs Fixes
- Switched back to Hotio Images to cut down on eating all your space!

#### [5.073] - 29 April 2018

  - Put 4k Versions of all programs in one area
  - Added New Role - CloudCMD (Thanks @Bryde)
  - Removed Hyrda1 in favor of Hydra2
  - Minor Bug Fixes
  - Fix made for PGTrak Path input (Thanks @John Doe)

#### [5.072] - 28 April 2018

- Patch 1
  - Read 5.073 / some fixes from there

- Added
 - Finished PGTrak & PGDupes (Both in BETA, please provide feedback to release 5.072 Stable)
 - New "PG PLEX Enhancement Tools" added to the menu
 - Some DummyProofing for those who do not like to read :D
 - PGDupe from DupeFinder
   - Tons of new scripts
   - All GUI for you!
- Changed
  - Revamped PG Enhancement Menu
  - Fix Quick Flash Load Error
  - Minor Bug Fixes
  - Improved PGDupes Network Address
 - Typo Fixes, Duplicati Fix, Emby Typo Fix - Mr Wensensday
 - Headphones, Typo Fixes, Lazy L. network fix - InfoMofo
 - Python Support Additon
 - Tons of Minor Bug Fixes  - Stop Plex From Disappearing on Rebuilds
- Removed
  - Unused Roles

### [5.071] - 22 April 2018

- Added
  - Fixed Preinstaller if you opted to make it run again
  - Added new menu item, PG Server Security
  - AppGuard and Port Status added to the menu
  - AppGuard is basically allowing Traefik to now password protect programs like NETDATA, RuTorrent, and Heimdall
  - Menu Dialogs for some information
  - Stopped Traefik Error Messages Flashing on Startup
  - Should prevent plex container from disappearing when upgrading or rebuilding mass containers
    - Report if it still happens and what you did
- Changed
  - Fixing Certificate Information on Startup
  - SABNZBD Fixes
  - Fixed up some of the PLEX Dialogs
- Known Issues
  - Pgstatus does not show proper IOwait, menu scaling issues

### [5.070] - 17 April 2018

Note: Traefik v2 may say your certificate is not valid if it is.  Know the fix, but don't have time to fix yet.  Will be updated in version 5.071

#### RC3
- Changed
  - Flicker-Rate put some fixes to the pgstatus program

#### RC2
- Added
  - @Flicker-Rate's PGStatus Program & Command
  - Minor Bug Fixes

#### RC1
- Added
  - Superstatus (PG status monitor) Beta 1.0 added
  - Ensured that folders are created with the correct permissions if 2nd HD is utilized
  - Startup Menu: Error Control was added and display if Traefik is not installed (incase bonehead uninstalled traefik)
  - Domains/Traefik: User exits with no version of Traefik Installed, it reminds them again!
- Changed
  - Fixed Solo HD Domain setup in settings; would go to wrong area prior
  - Adjusted Traefik startup variables, would give a false positive
  - Updated ending art to include pgstatus
- Removed
  - Ansible Duplicate Key Error Gone
  - Unused Ansible files for rclone cache (not stable yet)

#### BETA 4
- Changed
  - Fixed broken 2nd HD Link
- Removed
  - Dummy RClone File, this caused problems for some and wasn't needed!

#### BETA 3
- Added Password Notice if using Duplicati
- (SOLO HD) Improved Notifications
- (SOLO HD) Added Troubleshooting to the Menu
- (SOLO HD) Added Server Information to the MENU

#### BETA 2
- Added
  - Stopped the HTML folder from being left everytime you execute PG
  - (SOLO HD) automatic creation of folders when selecting the edtion under /mnt/unionfs

#### BETA 1
SOLO HD Version is being able to use only 1 drive and no google drive.  Good for small collections; or watch and delete@

- Added
 - Improved Solo HD Version, ready for testing
 - Fixes made to mp4 conversion (check wiki) - credit: allergictopineapple
 - duplicati role added by Mr. Wens
 - Clean up some of the menus
 - Added checkers to Solo HD Version (First BETA for it)

#### [5.069] - 10 April 2018

NOTE: You must rerun Traefik v2 and go through cloudflare again for proper updates of subdomain/domain!
NOTE: https://wiki.plexguide.com/books/3-pg-configuration/page/traefik-v2---cloudflare <<< Improved Instructions for CloudFlare

- Added
  - PG Solo HD Edition (NOT READY)
    - Useful for those who have only a single HD. Don't care about Google Drive; good for those with a small collection; or download, watch, delete types.
  - Startup Variable Page - Traefik 1 (Legacy) users will be notified of about certificate status
  - New Local PG Option with a new combined unionFS
    - WARNING, this does not work fully and should only be selected for testing purposes
  - Symbolic Link for HD2 so stuff bounces from /mnt/move to {hardrive2}/move
    - Note: If you already setup a second HD, rerun HD setup in settings for the symbolic link to kick in
  - BookSonic Role and Deployment - Credit: mrwednesday89
  - RClone Fixes - Credit: Zachawii
  - Tons of Misc Encrypted RClone Fixes - desgyz
  - CronJob Display Fix
  - Sped up the Install of Most Applications
  - Sped up cronjob installs
  - Improved valid certificate detection
  - Fixed Quick Flash at Startup in regards to certificates
  - NZBGET cron job, delete files older than 60 minutes (unprocessed) - Initial Credit: RXWatcher
  - Enhance PreInstaller Check
  - Menu Cleanup for Cronjobs
    - stored in one script
    - has a cronskip tag (some programs don't need cronjob backups)
  - Startup Menu Variable Fixes
  - Added Dupefinder - Credit MBCorps (unsure if working / testing required )
  - AirSonic Added - Credit Migz
  - Scan fixes/added - Credit MBCorps (unsure if working / testing required)
- Changed
  - TOML for Traefik v2 to allow domain to obtain https:// certificate (not just subdomains)
  - Fixed 2nd rebuild execution when adding a second HD
  - LOOP Preinstall Issue - This should be fixed now; made several changes.  
    - Note: When you run BETA2, you will have to do the preinstall once; afterwards, it should not occur
  - Heimdall works now with the reverse proxy, https://heimdall.domain.com - Credit: desgyz
  - Telly Port Fix - Credit: Migz
  - Fixed bad nzbget information (never affected plexguide), displayed port 5075 but it's 6789. - Thanks busanv (pgforums)
  - Fixed bash error flash before starting up of the program
  - Removed to del empty folder from rclone, caused problems - Credit MBCorps
  - Code Cleanup, added new cronskip function and remove large scripts to a solo one for cron exe

### [5.068] 7 April 2018

- Added
  - Added RClone install check for mass restore; warns users - Credit: Migz
  - Rebuilding Fix - Credit RXWatcher
  - New info.sh file at root to keep track of upgrading portions of PG (used, but not fully implemented)
  - Ombi4k from the following request: https://plexguide.com/threads/optional-extra-containers-for-4k-content.837/
    - Ombi4k: ombi4k.domain.com - port 3574
    - Traefik V1 Users: Have to rerun traefik
    - Added info.sh to root to keep track of static variables; mostly for the preinstaller
  - PLEX: Input CUSTOM ACCESS URL by lunchingfriar if not using CloudFlare
    - Info: https://plexguide.com/threads/beta-3-plexguide-5-068.903/
  - Startup Variable Page, displays info like IP, download points, if your Treafik Certifcate is valid and etc
    - Note: If using Traefik v1, will say not ready yet
  - Added not to rebuild Traefik v2 container based on certain situations IF certificate reports VALID
    - Note: Not set for Traefik v1
  - delayBeforeCheck for Docker
      - CREDIT: allergictopineapple (Discord)
  - PLEX Role: HW Transcoding by @MBCrop
  - Lol, spelling fixes (quite a bit) by @kaltec
  - PLEX - Local Servers / Virtual Machines - Plex Would be bugged for this case
    - If you select non-remote server, it will deploy a plex2 container which is on a host network and not exposed; basically works for the house or VM's
  - 4K Radarr AND 4K Sonarr from the following request: https://plexguide.com/threads/optional-extra-containers-for-4k-content.837/
    - Radarr4k: radarr4k.domain.com - port 7874
    - Sonarr4k: sonarr4k.domainn.com - port 8984

- Changed
  - Traefik v2 Users
    - Commented out port 8080, using SAB, must reload Traefik v2 - Fixed by allergictopineapple (Discord)
  - Traefik v1 - Updated traefikv1 TOML (you have to rerun traefikv1 again under settings, which is why v2 is better)

### [5.067] 4 April 2018

#### Note: Installing from 5.066 & Below will make you Register Your Domain Again (New System); plus for V1 or V2 Traefik

#### Stable - Final Add-Ons
- Added
  - HTML5 Speed Test Docker Container
    - Deploy Method #1 via server info > network benchmark > 5) SpeedTEST Server
    - Deploy Method #2 via PG Program Suite > Supporting > SpeedTEST Server
    - Treafik V2: Just work as speed.domain.com
    - Traefik V1: You need to redeploy Traefik again and then speed.domain.com (updated TOML / that's why v2 better)
    - CREDIT: Added by Migz < Awesome Find
- Changed
  - Commented out 8080 for Traefik, must reload so doesn't conflict with SABNZBD
    - 5.068 will support password protection for certian programs, not ideal to run until then
    - Fixed Initial Install Bug for 2nd HD, if created, didn't rebuild containers
  - Traefik V2
    - New functionality to allow the user to access both the rutorrent web interface and the flood web interface by using different hostnames
    - CREDIT: lunchingfriar
  - Improved Uninstaller
    - CREDIT: allergictopineapple (Discord)
- Removed
  - RClone --no-traverse removed from transfers
    - Requires redeployment, but not requires, doesn't affect anything
    - Stop log notificatons about rclone transfers longer being required
    - CREDIT: allergictopineapple (Discord)

#### RC3
- Added
  - Added ability to use a 2nd HD for PG
  - MP4 Automator added via AllergicToPineapple (Discord)
  - MP4 Automator permission issue fixed from BETA6
- Changed
  - Exit Initial Traefik setup; failing to setup warns user and no TRAEFIK runs (not critical if you accessing via IP or VM)
- Removed
  - Old Roles
  - Redudant Traefik Menu

#### RC2
- Added
  - Apache2-utils has been added to preinstaller for htpasswd generation for Treafik (not used for production yet)
  - TraefikV2 - Users are notified of additional domains that ombi and tatuilli can reach
- Changed
  - https: //redirection from Traefik TOMLS, redirection labels added per container for better control
  - Fixed minor mispellings
  - Removed TEST htaccess protection / traefik for netdata (a focus for version 5.068) due using hashes for passwords
  - Fixed BAD MariaDB Container location for NEXTCLOUD was /nexcloud - changed to /nextcloud (still bugged)

#### RC1
- Added
  - Improved Traefik's menu handling
  - Improved Message for Traefik Regarding Wildcards

#### BETA 5
- Added
  - LazyLibrarian Added - Haven't had much time to test, but deploys; please test out
  - Ombi Deploys To Main Domain Name (Will make optional for B6) TRAEFIKv2 Required
  - New Variable System for IP tracking and Ports Tracking; gone is the var.yml
- Changed
  - Fixed RClone Dummy File Install
- Removed
  - The pre.yml is gone, including the var.yml which caused headaches for people at times

#### BETA 4
- Added
  - Overhauled Domain Variable Recall / Storage
  - Added new and overhauled prior Redeployment System after changing Domain Names
  - Tracking on utilizing PG Traefik V1 & PG Tracking V2
  - Enhanced Dialog Menus for Better Tracking
  - With Traefik V2, user can type plexpy.domain.com or tautulli.domain.com
    - WORKING Domain Providers for V2: CloudFlare, Gandi, GoDaddy, NameCheap
  - Fixed Docker Install Glitch; rare times it wouldn't install; caused problems if uninstalled and reinstalled
  - Docker Install Speed up now checking for a specific version, if good; skips so not waiting
  - Uninstalling PlexGuide no longer causes issues with Docker
  - Working on wildcard https:// subdomains v2 implementation
- Changed
  - Rclone move now deletes empty directories, you may need to rerun rclone and quit for prior installs
  - Fixed Lazy Librain Role Location
  - Enhanced Ending Menu
- Removed
  - Several https:// redirects

#### BETA 3
- Added
  - Midnight Commander Installs via Ansible; no more menu glitches and etc
  - Docker 18.03 now installs over 17

#### BETA 2
- Added
  - Minor Bug Fixes

#### BETA 1
- Added
  - Sickrage: Fixed subdomain; now works
  - Sped up the Base Installer (about 25 percent); forcing more items to install via background

#### Known Issues
- (Tracking) https://hemidall domain not working via subdomain (reverse proxies)
- (Tracking) pyload is not working
- (Tracking) nextcloud bugged

### [5.066 PL1]

#### Added
- Bug Fix: Stop deletion of domain upon forced upgrades
- Bug Fix: Code for menu glitches if you cancel out of plex install & ask if you already claimed
- Flicker's Server Speed Network Enhancement (View Settings)
- Flicker's SuperSpeed Emergency Repair Patch

#### Changed
- PD4 Restart for those it drops on
- (Emergency) Glitch with PD Image; repaired emergency update
- Minor changes to PlexDrive
- Migz - submitted a pull request to fix rutorrent mappings!

#### Removed
- Some Old Menus

### [5.065]

#### Added
- OS Check / Warns User if not using 16.04 - Prompts only one time!
- Attempted to correct odd display of UI in Putty / works
- Added Password Checks for nzbhydra (1 & 2), resilio, emby, jackett & medusa
- Automatic Reboot after Installing or Rerunning PlexDrive 4 or PlexDrive 5
- Nonempty tag added on the PlexDrive
- Handling Ability to Switch Between PD4 and PD5; scripts reboot system if switching to assist

#### Changed
- Fix Closed/Open Port Settings; new menu, reconstructs all containers
- Fix Multiple instances of supertransfer running if systemd service is restarted
- Fix False positive on SSL check
- Added systemd requirement dependencies for plexdrive, unionfs & transfer services
    - *should* fix "endpoint error not connected" error (reported by japandler)

#### Removed
- None

#### Known Issues
- pyload is not working
- next cloud https:// domain not working, but port access is
- supertransfer sometimes uploads duplicates (reported by lolmattylol)

### [5.064]

#### Added
- Ansible bug test role added to menu
- Warns users if domain is configured wrong and proposes troubleshooting steps
- Warns users if they forgot to set a password
- Added  a e s t h e t i c s  To PG Exit Message
- Added Migration Option - Now you can import existing data to be uploaded into gdrive
- Fresh Install - RClone: When going to RClone Menu, installs a dummy file to ensure drive is named gdrive!
- ClowPlow Role (serves to only as a nerfed/cleaner) modification from Design Gears
  - Original Tool Credit: l3uddz/cloudplow
  - Installs properly when using RCLONE unencrypted and going through it again (might work encrypted later)
  - If PG is already installed and CONDUCTING AN UPDATE from 5.063 & Below, type -- sudo ansible-role clean

#### Changed
- Removed Buggy Animations for PlexDrive install menus
- Tweaked Update Menu yes/no dialog
- Changed Migration Option Name to "Import Media"
- Fixed a menu info glitch regards to watchtower
- Fixed PlexDrive Install Glitch

#### Removed
- NERFED Subdomain check (was not ready)

### [5.063]

#### Added
- New Installs, fixed initial pushover prompt
- Reorders pushover menu
- Install new WatchTower Menu; gives user option in regards to auto updates

#### Changed
- Changed to all Linux Server Images
- Disabled CloudPlow Install (did not do anything)

#### Removed
- None

#### Known Issues
- pyload is not working
- turnin off ports may not work in settings <<< might be fixed (have to test more)
- next cloud https:// domain not working, but port access is

### [5.062]

#### Added
- Ubooquity works, read instructions carefully in wiki on how to access
- Added Pushover Role, now can call up easily in bash - Ansible is my work horse :D
- (SuperSpeed) Flicker-Rate's Multi-Gdrive Upload Option Added; ansible updated.
- NextCloud Container works; access via domain:port only
- For Uncapped; added a deamon reload; critical because move.service will never disable
- Added Press Key To Continue after all speed tests; previously would exit soon as it finished printing results
- Moving Animiation to Solo Restore & Backup to show the program is working; removed ansible display for solo process
- (Pushover) notification system added and to various scripts
- Pushover & SuperSpeed Added-Amended to Settings

#### Changed
- Further enhanced locations and notifications of Pushover
- Container Starts up after a local backup is made on the server; speeds up pending container use
- PlexDrive - Fixed up to ensure service works properly when installing for the first time
- Changed SAB to port 8080; https:// now works for SABNZBD
- Changed Ombi Source / Requires a rerun if you had ombi setup from before!

#### Removed
- Several https:// no redirects, legacy code
- Streamlined PlexDrive Script; tossed older legacy scripts (no older prompts)

#### Known Issues
- pyload is not working
- turnin off ports may not work in settings <<< might be fixed (have to test more)
- next cloud https:// domain not working, but port access is

### [5.061]

#### Added
- Mass Restore: Traefik file is chmod to 0600 to prevent file permission issues (Reported By: Flicker-Rate)
- Enabling System Health Monitoring (Credit: EasternPA)
- Dialog asks for your username and email
- Added New Menu to Settings Incase You Have To Change
- Can type your own new custom plex tag (useful for certain version, or if newest plex is bugged)
- New Menus for Plex Install with Checks including asking for if user has remote server
- PreInstall Docker Checker - If Docker cannot installs, it lets the user know common reasons why; cuts down on issues

#### Changed
- Mass Restore: User is notified to deploy each app after a mass restore (Reported By: Flicker-Rate)
- PlexDrive Fix (Credit: budman17r)
- Overhauled Plex Install System
- Fixed Typo in PG Server Info Menu

#### Removed
- Ansible asking you about domain and email, prevents stopping midinstalls (or babysitting to wait around)
- Removed one useless press enter during ansible install of plex
- Removed Use Plex Menus

#### Known Issues
- pyload is not working
- turnin off ports may not work in settings <<< might be fixed (have to test more)
- nextcloud not working
- SABNZBD https:// maybe not working?

#### To Do
- Add Traefik Labels for reverse Proxy Protection
- Update Heimdall for Protection

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
