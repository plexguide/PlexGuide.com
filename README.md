<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/plexguide-logo5.PNG?raw=true" alt="PlexGuide.com Logo"/>
</p>

[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/admin9705/PlexGuide.com-The-Awesome-Plex-Server.svg)](http://isitmaintained.com/project/admin9705/PlexGuide.com-The-Awesome-Plex-Server "Average time to resolve an issue") [![Percentage of issues still open](http://isitmaintained.com/badge/open/admin9705/PlexGuide.com-The-Awesome-Plex-Server.svg)](http://isitmaintained.com/project/admin9705/PlexGuide.com-The-Awesome-Plex-Server "Percentage of issues still open") [![first-timers-only](http://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square)](http://www.firsttimersonly.com/)


[![N|Solid](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/discord-button.PNG?raw=true)](https://discord.gg/mg7bVnw)
----------------------------------------------------------------------
**Tip**: Did you know if you click the star in the upper right, it promotes our project further on GITHUB?

### PlexGuide - Version 5 - Coded By:
- [Admin9705](https://github.com/Admin9705), [Deiteq](https://github.com/Deiteq) & [The Creator](https://github.com/TheCreatorzOne) 

### Awesome Beta Testers & Contributers!
- Augie, [AugusDogus](https://github.com/AugusDogus), [Bate](https://github.com/batedk), cocainbiceps, [daveftw84](https://github.com/daveftw84), Jackalblood, imes, NickUK, Pentaganos, trustyfox, [Rothuith](https://github.com/Rothuith), simon021, SpencerUK

- This is a community driven project. You can spot errors, update the wiki, contribute code, suggest ideas! This project would not exist without the help of you and others!

### Awesome Beta Testers & Contributers!
- **UBUNTU 16.04 & 17.04 ** Only !!! PlexGuide is not MADE FOR SERVER EDITONS 16.10 - 17.10**
- This will remain as developer version for quite some time.  We keep adding & fixing things!

### Social
- [PlexGuide Discord Channel](https://discord.gg/mg7bVnw) 
- Reddit Discussion Link: http://reddit.plexguide.com

### Want to Donate? Everybit Helps!

**Support US**: Purchase multiple crypto-curriencies via http://binance.plexguide.com - Purchase Stellar & Ripple! Value increased 4 times from late Dec 17 thru Jan 18!

- Bitcoin : 1H3SD3ef6qaN8ND8S8ZQCaEyD4pMW4kFsA
- LiteCoin: LbCDaq26N39TuUarBkrxTXNFjsNWds9Ktj

----------------------------------------------------------------------

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/Snip20180103_143.png" alt="Demo"/>
</p>

[![N|Solid](https://camo.githubusercontent.com/348b82630f4f5be3c775c9caed3bb5765b0b3018/687474703a2f2f692e696d6775722e636f6d2f785370773438322e706e67)](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) [![N|Solid](https://camo.githubusercontent.com/653f9f8e115242dddb8f6282d17c8ef550844294/687474703a2f2f692e696d6775722e636f6d2f6d464f304f75582e706e67)](http://feathub.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server)

### Preparation, Installation & Configuration

**A. Quick Notes:**
- Lightly check the PlexGuide Wiki @ http://wiki.plexguide.com
- With a GITHUB login, did you know that you can edit our wiki pages?! Yes, you can make corrections, add snapshots or expand on any topic. IF you make an update, you'll save us time and help others! Some users have already helped us!

**B. Pre-Preparation:**
- Purchase a [Google Suite Drive Account](https://gsuite.google.com) via Unlimited Storage.
- Have a Dedicated, VPS, or Home Solution Ready!
  - [Recommended EU Servers](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/EU-Servers)

** Recommend Space Requirements
- Plex Only Server: Small Library (30GB-50GB) - Large Library (100GB+):
- Plex with USENET or Torrents: Small Library (80GB-100GB+) - Large Library (200GB-300GB+)
- Notes:
  - Example:  MetaDATA of 10000 Movies and 2000 shows can run 80Gigs big 
  - Warning:  If backing up your library, you need space for the additional zip file!

**C. Preparation:**
 - [Google Drive Layout](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Google-Drive-Layout)
 - [Do you Require SSH Access?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Access-via-SSH)
 - [Do you Require a SUDO User?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Creating-a-SUDO-User)
 - [Disk Space Warning Check!](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Disk-Check-Warning!)

**D. Install Instructions:**

*Recommened First to Prevent Issues*
```sh
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get full-upgrade -y
```
Ensures that the distro has it's dependencies updated and no updates are queued.

*Install Supporting Programs*
```sh
sudo apt-get install git -y && sudo apt-get install whiptail -y
```
Important as if you do not have git and whiptail; you will not be able to fetch and run PlexGuide!

*Install PlexGuide*
```sh
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
```
```sh
sudo bash /opt/plexg*/sc*/ins*
```

*Execute PlexGuide AnyTime Futurewise*
```sh
plexguide
```

**E. Set CPU Performance**
- Only use for a REAL Machine; useless for a virtual machine
- Select [Set CPU Performance]
- Select Performance mode for best result; default is OnDemand mode
- Screenshot of Performance Mode | Screenshot of OnDemand Mode | Screenshot of Conservative Mode

**F. Benchmarks**
- Select [Server/Net Benchmarks] on the PlexGuide front Menu
- It is a good idea to check your benchmarks prior to setting up everything else
- Remember to conduct multiple tests if you feel uneasy about your results

**G. RClone / PlexDrive / UnionFS**
 - Install & Configure (Select Only One)
 - YouTube Demo Video (V2) for RClone, UnionFS & PlexGuide: https://youtu.be/T0eXtrOY4kw
   - [RClone Unencrypted Version](http://unrclone.plexguide.com)  
   - [RClone Encrypted Version](http://enrclone.plexguide.com)   
 - [Configure PlexDrive](http://plexdrive.plexguide.com) Note: Let It Finish and then Reboot the Server!

**H. (Optional) Setting Up Your Reverse Proxy**

Traefik Reverse Proxy - Access Your Apps Via a Subdomain (Ex: radarr.domain.com or netdata.domain.com)

 - [Configuring Traefik Reverse Proxy](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Traefik-Reverse-Proxy)
    - How To With a Paid GoDaddy Domain: [GoDaddy Instructions](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Godaddy-Domain-to-IPv4-Instructions)
    - How To With a FreeNom Domain     : [NomNom Instructions](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/FreeNom-Domain-to-IPv4-Instructions)


**I. Installing & Setting Up Support Programs**

 - [Configure Plex](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Plex-Guide)
 - [Configure Programs](http://wiki.plexguide.com) on the ***Right Hand Side***
 - [Configure Portainer](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Portainer)
 - [Port Numbers Reminder](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Port-Assignments)

**J. Final Notes**
- See issues or have solutions? Please post your [GitHub Issues for the Best Tracking](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) or our [REDDIT](http://reddit.plexguide.com).
- Please visit: https://www.reddit.com/r/PleX/ for additonal support and information!
- Your Feedback Helps Us and You!
