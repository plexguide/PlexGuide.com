# Purpose

This section is mandatory to execute.  Basically, you are establishing plexdrive, rclone, and unionfs in order to read, write, and upload files to your google drive. Ensure that you have your google drive api ready (how to obtain in instructions) and configure accordingly.  

### PlexDrive4 

Is a read-only file system that enables plex to scan your google drive without resulting in an API ban.  PlexDrive4 is utilized over PlexDrive5 due to stability.  PlexDrive4 caches files to your hard drive instead of RAM over PlexDrive5.  When you establish your PlexDrive, ensure that you let it FINISH scanning before anything else.  This process can take a few minutes or over the course of several hours.

### RClone

A program that has the capability to mount a drive with read and write capabilities.  The question asked, why not just use Plex to read an rclone directory.  The answer is that it will result in a 24 API ban.  RClone servers it purpose her to sync your downloaded files to your google drive by utilizing the sync command.  A move/sync service will be created to ensure that you transfer no more than 750GB per day.  A larger upload will result in a 24 API UPLOAD ban and will require you to reboot your server.  

### UnionFS

A program that merges multiple directories into one directory.  The problem that you will run into is that you will attempt to have SONARR and RADARR read your PlexDrive.  The only problem is that PlexDrive is a read-only directory.  When your files download, you will not have the ability to upload your files.  To get around that, UNIONFS will take your plexdrive read only directory and your local drive create a directory to trick Sonarr and Radarr to not only read files, but result the downloading of files to your local drive.  Since the files stay on your local drive, a move service will sync the files from your local drive to your google drive.  Basically, your putting up a cloak and dagger, moving the files, and deleting of your local drive in the end.  Think about it; remember that plexdrive is a read-only merged with your local? Well, your files that got upload now are part of plexdrive which again is scanned by Raddar and Sonarr as complete.

### Encryption or No Encryption

You must only use one.  See the pros and cons in each file.


