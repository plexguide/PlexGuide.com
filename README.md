# PlexGuide.com - Version 5

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/plexguide.PNG" alt="PlexGuide.com Logo"/>
</p>

---------------------------------------------------------------------- 
### Basic Information
- Written By [Admin9705](https://github.com/Admin9705) and [Deiteq](https://github.com/Deiteq)
- Slack Autoinvite: http://invite.plexguide.com and Slack # @ https://plexguidecom.slack.com (Preferred)
- Reddit Discussion Link: http://reddit.plexguide.com (Secondary)
- UBUNTU 16.04 & 17.04 Only !!! Not for Server (.10) versions!

### Want to Donate? Everybit Helps!

- Bitcoin : 1H3SD3ef6qaN8ND8S8ZQCaEyD4pMW4kFsA
- LiteCoin: LbCDaq26N39TuUarBkrxTXNFjsNWds9Ktj

----------------------------------------------------------------------

### Preparation, Installation & Configuration 

**A. Quick Notes:**
- Lightly check the PlexGuide Wiki @ http://wiki.plexguide.com
- With a GITHUB login, did you know that you can edit our wiki pages?! Yes, you can make correctons, add snapshots or expand on anytopic. IF you make an update, you'll save us time and help others! Some users have already helped us!

**B. Pre-Preparation:**
- Purchase a [Google Suite Drive Account](https://gsuite.google.com) via Unlimited Storage.
- Have a Dedicated, VPS, or Home Solution Ready!
  
**C. Preparation:**
 - [Google Drive Layout](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Google-Drive-Layout)
 - [Do you Require SSH Access?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Access-via-SSH)
 - [Do you Require a SUDO User?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Creating-a-SUDO-User)
 - [Disk Space Warning Check!](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Disk-Check-Warning!)
 
**D. Install Instructions:**

*Install Supporting Programs*
```sh
sudo apt-get install git
```

*Install PlexGuide*
```sh
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/sc*/ins*
```

*Execute PlexGuide AnyTime Futurewise*
```sh
plexguide
```
  
**E. Configuration**
 - Install & Configure (Select Only One)
   - [RClone Unencrypted Version](http://unrclone.plexguide.com)  
   - [RClone Encrypted Version](http://enrclone.plexguide.com)   
 - [Configure PlexDrive](http://plexdrive.plexguide.com) Note: Let It Finish and then Reboot Server!
 - [Configure Plex](http://plex.plexguide.com)
 - [Configure Programs](http://wiki.plexguide.com) on the ***Right Hand Side***
 - [Configure Portainer](http://portainer.plexguide.com)
 - [Port Numbers Reminder](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Port-Assignments)

**F. Final Notes**
- See issues or have solutions? Please post your [GitHub Issues for the Best Tracking](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) or our [REDDIT](http://reddit.plexguide.com). 
- Please visit: https://www.reddit.com/r/PleX/ for additonal support and information!
- Your Feedback Helps Us and You! 

**G. Quick Troubleshoot**
- Docker Install Failure: If Docker refuses to install, visit Tools and force the reinstall. If that fails; most likely you are running an older version of UB or have a VPS service that runs and outdated kernal. [[Manual Docker Install Incase]](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository)
