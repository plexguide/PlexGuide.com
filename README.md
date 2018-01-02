# PlexGuide.com - Version 5

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/plexguide-logo5.PNG?raw=true" alt="PlexGuide.com Logo"/>
</p>

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/preview02.png?raw=true" alt="PlexGuide.com Preview"/>
</p>

----------------------------------------------------------------------
## Social
- [PlexGuide Discord Channel](https://discord.gg/mg7bVnw) [![N|Solid](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/discord-button.PNG?raw=true)](https://discord.gg/mg7bVnw)
- Reddit Discussion Link: http://reddit.plexguide.com


### Basic Information
- Written By [Admin9705](https://github.com/Admin9705) and [Deiteq](https://github.com/Deiteq)
- Additonal Code Crew: [The Creator](https://github.com/TheCreatorzOne)
- **UBUNTU 16.04 & 17.04 ** Only !!! PlexGuide is not MADE FOR SERVER EDITONS 16.10 - 17.10**
- **Tip**: Did you know if you click the star in the upper right, it promotes our project further on GITHUB?
- This will remain as developer version for quite some time.  We keep adding & fixing things!

### Awesome Beta Testers & Contributers!

- This is a community driven project. You can spot errors, update the wiki, contribute code, suggest ideas! This project would not exist without the help of you and others!

- Augie, [AugusDogus](https://github.com/AugusDogus), [Bate](https://github.com/batedk), cocainbiceps, [daveftw84](https://github.com/daveftw84), Jackalblood, imes, NickUK, Pentaganos, trustyfox, [Rothuith](https://github.com/Rothuith), simon021, SpencerUK

### Want to Donate? Everybit Helps!

- Bitcoin : 1H3SD3ef6qaN8ND8S8ZQCaEyD4pMW4kFsA
- LiteCoin: LbCDaq26N39TuUarBkrxTXNFjsNWds9Ktj

----------------------------------------------------------------------

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
- Running Plex Only:
  - Small Library (30GB-50GB)
  - Large Library (100GB+):
- Plex with Downloading/Uploading
  - Small Library (80GB-100GB+)
  - Large Library (200GB-300GB+)
- Notes:
  - Example:  The metadata of 10000 Movies and 2000 shows alone can run 80Gigs
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
sudo apt-get install git && sudo apt-get install whiptail
```
This one is important as if you do not have git and whiptail you will not be able to fetch and run PlexGuide!

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

**E. Benchmarks**
- Select [Server/Net Benchmarks] on the PlexGuide front Menu
- It is a good idea to check your benchmarks prior to setting up everything else
- Remember to conduct multiple tests if you feel uneasy about your results

**F. RClone / PlexDrive / UnionFS**
 - Install & Configure (Select Only One)
 - YouTube Demo Video (V2) for RClone, UnionFS & PlexGuide: https://youtu.be/T0eXtrOY4kw
   - [RClone Unencrypted Version](http://unrclone.plexguide.com)  
   - [RClone Encrypted Version](http://enrclone.plexguide.com)   
 - [Configure PlexDrive](http://plexdrive.plexguide.com) Note: Let It Finish and then Reboot the Server!

**G. (Optional) Setting Up Your Reverse Proxy**

Traefik Reverse Proxy - Access Your Apps Via a Subdomain (Ex: radarr.domain.com or netdata.domain.com)

 - [Configuring Traefik Reverse Proxy](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Traefik-Reverse-Proxy)
    - How To With a Paid GoDaddy Domain: [GoDaddy Instructions](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Godaddy-Domain-to-IPv4-Instructions)
    - How To With a FreeNom Domain     : [NomNom Instructions](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/FreeNom-Domain-to-IPv4-Instructions)


**H. Installing & Setting Up Support Programs**

 - [Configure Plex](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Plex-Guide)
 - [Configure Programs](http://wiki.plexguide.com) on the ***Right Hand Side***
 - [Configure Portainer](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Portainer)
 - [Port Numbers Reminder](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Port-Assignments)

**I. Final Notes**
- See issues or have solutions? Please post your [GitHub Issues for the Best Tracking](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) or our [REDDIT](http://reddit.plexguide.com).
- Please visit: https://www.reddit.com/r/PleX/ for additonal support and information!
- Your Feedback Helps Us and You!

**J. Quick Troubleshoot**
- Docker Install Failure: If Docker refuses to install, visit Tools and force the reinstall. If that fails; most likely you are running an older version of UB or have a VPS service that runs and outdated kernel. [[Manual Docker Install Incase]](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository)
